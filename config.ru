require 'rubygems'
require 'sinatra'
require ::File.expand_path('../config/initializer', __FILE__)
require ::File.expand_path('../app/app', __FILE__)
require 'sidekiq/web'

root = ::File.dirname(__FILE__)
logfile = ::File.join(root,'log', 'sinatra.log')

run Rack::URLMap.new(
  '/'         => SemanticApiAgent,
  '/sidekiq'  => Sidekiq::Web,
  '/ha-check' =>
    lambda do |env|
      [ 200, {"Content-Type" => 'application/json'}, ['{"status": "ok"}'] ]
    end
)

