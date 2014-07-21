require 'sinatra/base'
require './lib/workers/api_request_job'
require './app/helper/key_terms_helper'

class SemanticApiAgent < Sinatra::Base
  helpers Sinatra::KeyTermsHelper

  get '/hi' do
	  "Hello World!!!"
  end
  
  # Returns top n terms
  get '/top_terms/?:n?/?:channel_type?/?:channel_id?' do
    if params[:n].nil?
      response = top_terms(20, params[:channel_type], params[:channel_id])
    else
      response = top_terms(params[:n], params[:channel_type], params[:channel_id])
    end
    response
  end
end
