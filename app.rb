require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'coffee-script'
require 'json'

class Module
  def modules
    constants.select { |c| const_get(c).kind_of? Module }
  end
end

helpers do
  def json(value)
    content_type :json
    value.to_json
  end
end

get '/application.css' do
  scss :application
end

get '/application.js' do
  coffee :application
end

get '/data.json' do
  data = {
    name: 'Sinatra',
    children: Sinatra.modules.sort.map { |c| { name: c.to_s } }
  }
  json data
end

get '/' do
  slim :index
end
