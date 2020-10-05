# Fixer Proxy
Test task for Freska.
Microservice that proxies Fixer API endpoint for historical currency conversion rates.

## To start up
Make sure that a recent Ruby version is installed(tested on 2.6.x).
```
git clone git@github.com:NikolayRys/fixer_proxy.git && cd fixer_proxy
bundle install
ruby server.rb
```
It starts server on default Sinatra port `http://localhost:4567/`

## Usage
Endpoint that mimics [Fixer API Historic endpoint](https://fixer.io/documentation).
Accept date in YYYY-MM-DD format.
Optionally allows to pass the list of required currency symbols.
If not provided, defaults to all known 168 symbols.

Example:
`http://localhost:4567/2020-10-04?symbols=USD,AUD,CAD,PLN,MXN`

## Where I have drawn the line
* I did not implement `timeseries` endpoint because it's not used by the reporter and would extend scope beyond 4 hours.
* The only supported base currency is EUR, because of API limitations. It's possible to make conversions through EUR.

What else I would have done if I had more time:
* Add tests
* Dockerize both services and add orchestration as docker-compose

## Notes
* Related repo: https://github.com/NikolayRys/delta_reporter
* Fixer API key is not required, and is handled by the application.
* Root URL returns short description with a usage example.
* EUR symbol is excluded from both HTTP calls and DB storage, since it never changes.
* Amount of cache hits is logged to console.
* To reset local DB: `rm cache.db`
* All recognized symbols:
```
AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BRL BSD BTC BTN BWP BYN BYR
BZD CAD CDF CHF CLF CLP CNY COP CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GGP GHS GIP GMD GNF
GTQ GYD HKD HNL HRK HTG HUF IDR ILS IMP INR IQD IRR ISK JEP JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR
LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP
PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD
TZS UAH UGX USD UYU UZS VEF VND VUV WST XAF XAG XAU XCD XDR XOF XPF YER ZAR ZMK ZMW ZWL
```
