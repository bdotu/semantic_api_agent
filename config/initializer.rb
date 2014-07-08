RACK_ENV = ENV['RACK_ENV'] || 'development'

require 'rubygems'
require 'yaml'
require 'sinatra'
require 'redis'
require "sidekiq"
require 'logger'
require 'brokerizer/broker'
require 'brokerizer/errors'

$project_root = File.expand_path('.')

# $settings = YAML.load_file('config/settings.yml')[RACK_ENV]
# $sidekiq_settings = YAML.load_file('config/sidekiq.yml')[RACK_ENV]

Broker.init($project_root, [:database, :redis, :sidekiq])

DB = Broker.database
require './config/sequel'

$rabbitmq_config = YAML.load_file('config/rabbitmq.yml')[RACK_ENV].symbolize_keys