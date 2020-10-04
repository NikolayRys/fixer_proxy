require 'sinatra'
require 'dotenv/load'
require 'httparty'

FIXER_API_URL = 'http://data.fixer.io/api'

get '/' do
  url = "#{request.base_url}/"
  "Mimics <a href=\"https://fixer.io/documentation\">Fixer API</a>.
  Available endpoints:<br>#{url}latest<br>#{url}YYYY-MM-DD<br>
  Supported param: '&symbols = USD,AUD,CAD,PLN,MXN'<br>
  Access key is not required and is handled by this proxy."
end

get '/latest' do
  get_from_fixer(request.path, request.params).to_s
end

get /\/(\d{4})-(\d{2})-(\d{2})/ do
  get_from_fixer(request.path, request.params).to_s
end

def get_from_fixer(endpoint, params)
  params[:access_key] = ENV['FIXER_ACCESS_KEY']
  HTTParty.get("#{FIXER_API_URL}#{endpoint}", query: params)
end
