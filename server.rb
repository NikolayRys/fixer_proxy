require 'sinatra'
require 'httparty'
require_relative 'connect_to_storage'

FIXER_API_URL = 'http://data.fixer.io/api'.freeze

FIXER_ACCESS_KEY = '2c471a7a78dfc3b90c813189c7a63b7f' # Assuming these are configured on each server and are not commited to repo

STATIC_SYMBOL = 'EUR'.freeze # Euro-to-euro doesn't change, so we don't send nor store it

KNOWN_SYMBOLS = %w[AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BRL BSD BTC BTN BWP BYN BYR
BZD CAD CDF CHF CLF CLP CNY COP CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB FJD FKP GBP GEL GGP GHS GIP GMD GNF
GTQ GYD HKD HNL HRK HTG HUF IDR ILS IMP INR IQD IRR ISK JEP JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR
LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP
PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD
TZS UAH UGX USD UYU UZS VEF VND VUV WST XAF XAG XAU XCD XDR XOF XPF YER ZAR ZMK ZMW ZWL].freeze

CACHE_DB = connect_to_storage

get '/' do
  url = "#{request.base_url}/"
  "Proxy for <a href=\"https://fixer.io/documentation\">Fixer API</a>.<br>
  Access key is not required and is handled by this proxy.<br>
  Endpoint for historical currency rates is available: <a href=\"#{url}2020-10-04\">example.</a><br>
  Supported param: '&symbols = USD,AUD,CAD,PLN,MXN'<br>"
end

get /\/(\d{4})-(\d{2})-(\d{2})/ do
  date, requested_symbols, with_static = interpret_params(request)

  rates_hash = fetch_rates_from_db(requested_symbols, date)
  missing_symbols = requested_symbols - rates_hash.keys

  if missing_symbols.any?
    puts "*** Haven't found #{missing_symbols.size} symbols locally, sending API request ***"
    new_rates_hash = fetch_rates_from_fixer("/#{date}", missing_symbols)
    record_new_rates_to_db(new_rates_hash, date)
    rates_hash.merge!(new_rates_hash)
  else
    puts "*** All symbols found locally, not sending API request ***"
  end
  rates_hash['EUR'] = 1.0 if with_static

  mimic_fixer_json(rates_hash, date)
end

def mimic_fixer_json(rates_hash, date)
  content_type 'application/json'
  {
    success: true,
    timestamp: Time.now.to_i,
    historical: true,
    base: STATIC_SYMBOL,
    date: date,
    rates: rates_hash.sort.to_h
  }.to_json
end

def interpret_params(request)
  date = request.path.delete_prefix('/')
  if (raw_symbols_str = request.params['symbols'])
    symbols_str = CGI.unescape(raw_symbols_str)
    requested_symbols = symbols_str.split(',')
    with_static = !!requested_symbols.delete(STATIC_SYMBOL)
  else
    requested_symbols = KNOWN_SYMBOLS
    with_static = true
  end

  [date, requested_symbols, with_static]
end

def fetch_rates_from_fixer(endpoint, symbols)
  response = HTTParty.get("#{FIXER_API_URL}#{endpoint}", query: {access_key: FIXER_ACCESS_KEY, symbols: symbols.join(',')})
  response.fetch('rates', {})
end

def fetch_rates_from_db(requested_symbols, date)
  symbols_query = requested_symbols.map{|symbol| "'#{symbol}'"}.join(',')
  CACHE_DB.execute("SELECT symbol, rate FROM quotations WHERE date='#{date}' AND symbol IN (#{symbols_query})").to_h
end

def record_new_rates_to_db(rates_hash, date)
  rates_hash.each { |symbol, rate| CACHE_DB.execute("INSERT INTO quotations VALUES ('#{symbol}', '#{date}', #{rate})") }
end
