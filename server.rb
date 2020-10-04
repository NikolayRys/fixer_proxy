require 'sinatra'
require 'dotenv/load'

FIXER_API_URL = 'http://data.fixer.io/api/'

get '/' do
  url = "#{request.base_url}/"
  "Mimics <a href=\"https://fixer.io/documentation\">Fixer API</a>.
  Supported endpoints:<br>#{url}latest<br>#{url}YYYY-MM-DD<br>#{url}convert<br>#{url}timeseries<br>#{url}fluctuation"
end

get '/latest' do

end

get '/YYYY-MM-DD' do

end

get '/convert' do

end

get '/timeseries' do

end

get '/fluctuation' do

end
