require 'sinatra/base'

class SemanticApiAgent < Sinatra::Base
  
  get '/hi' do
    "Hello World!!!"
  end

end
