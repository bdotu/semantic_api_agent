source 'http://rubygems.org'

gem 'activesupport'
gem 'bunny'
gem 'sinatra'
gem 'unicorn'
gem 'sequel'
gem 'sqlite3'
gem 'faraday', '0.8.9'
gem 'mime-types',                   '1.19', :require => "mime/types"
gem 'redis',                        '~> 3.0.4'
gem 'typhoeus'
gem 'pry'
gem 'rake'
gem 'sidekiq'
gem 'sidekiq-middleware'
gem 'sidekiq-failures'
gem 'event-subscriber',             :git => 'https://075f5f799dc6cfd1d44e4b5c8db6094ded0cd9e7:x-oauth-basic@github.com/vitrue/event-subscriber.git', :branch => 'yizjiang/broker_event'
gem 'logger'
gem 'brokerizer',                   :git => 'https://075f5f799dc6cfd1d44e4b5c8db6094ded0cd9e7:x-oauth-basic@github.com/vitrue/brokerizer.git', :tag => 'v1.1.0'
gem 'gatekeeperizer',               :git => 'https://075f5f799dc6cfd1d44e4b5c8db6094ded0cd9e7:x-oauth-basic@github.com/vitrue/gatekeeperizer.git', :tag => 'v1.0.5'

group :test do
  gem 'simplecov', :require => false
  gem "rspec"
  gem 'capybara'
  gem 'webmock'
  gem 'vcr'
  gem 'selenium-webdriver'
  gem 'database_cleaner', '1.2.0'
  gem 'jasmine'
  gem 'protected_attributes'
end

group :test, :develop do
  gem 'debugger'
end
