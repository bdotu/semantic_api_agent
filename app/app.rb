require 'sinatra/base'
require './lib/workers/api_request_job'

class SemanticApiAgent < Sinatra::Base
  
  get '/hi' do
    "Hello World!!!"
  end

  get '/hello' do
  	"Goodbye World!!!"
  end

  get '/test' do
  	"#{KeyTerm.all.inspect}"
  end
end
