# encoding: utf-8

require 'sidekiq'
require 'sidekiq-failures'
require 'sidekiq-middleware'

require './lib/workers/workers_entrypoint'
require './config/initializer'

redis_config = YAML.load_file("./config/redis.yml")[RACK_ENV]

Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV['REDIS_URL'] || "redis://#{redis_config['host']}:#{redis_config['port']}/#{redis_config['db']}",
    namespace: redis_config['namespace']}
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV['REDIS_URL'] || "redis://#{redis_config['host']}:#{redis_config['port']}/#{redis_config['db']}",
    namespace: redis_config['namespace']}
end
