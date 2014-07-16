require 'sinatra/base'
require './lib/workers/api_request_job'
require './app/helper/key_terms_helper'

class SemanticApiAgent < Sinatra::Base
	helpers Sinatra::KeyTermsHelper

	get '/hi' do
		"Hello World!!!"
	end

	get '/test' do
		KeyTerm.where('id < 6').all.inspect
	end

	get '/top_terms/:n' do
		response = top_terms(params[:n])
		response
	end

end
