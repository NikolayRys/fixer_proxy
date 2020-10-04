require 'sinatra'
require 'dotenv/load'
require 'httparty'

FIXER_API_URL = 'http://data.fixer.io/api/'

get '/' do
  url = "#{request.base_url}/"
  "Mimics <a href=\"https://fixer.io/documentation\">Fixer API</a>. Access key is not required.
  Supported endpoints:<br>#{url}latest<br>#{url}YYYY-MM-DD<br>#{url}convert<br>#{url}timeseries<br>#{url}fluctuation"
end

get '/latest' do
  get_from_fixer('latest').to_s
end

get '/YYYY-MM-DD' do
  # ^(\d{4})-(\d{2})-(\d{2})
end

get '/convert' do

end

get '/timeseries' do

end

get '/fluctuation' do

end

def get_from_fixer(endpoint, params={})
  params[:access_key] = ENV['FIXER_ACCESS_KEY']
  HTTParty.get("#{FIXER_API_URL}#{endpoint}", query: params)
end
