require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'coffee-script'
require 'json'

class ModulesGraph
  attr_reader :tree

  def initialize(const)
    @tree = build(const)
  end

  protected

    def build(const)
      {
        name: const.name.split('::').last,
        path: const.name.gsub('::', '/'),
        children: nested_modules(const)
      }
    end

    def nested_modules(const)
      return [] if const.is_a? Class
      const.constants
        .sort
        .map { |c| const.const_get(c) }
        .select { |c| c.is_a? Module }
        .map { |c| build(c) }
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
  json ModulesGraph.new(Sinatra).tree
end

get '/' do
  slim :index
end
