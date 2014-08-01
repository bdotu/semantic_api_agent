ENV['RACK_ENV'] = 'test'

require 'capybara'
require 'capybara/dsl'
require 'faraday'
require 'typhoeus/adapters/faraday'
require 'selenium/webdriver'
require 'rack/test'
require 'vcr'
require 'database_cleaner'
require 'active_support/core_ext/object'
require 'json'
require './config/initializer'
require './config/sequel'
require 'brokerizer/errors'

require 'simplecov'
SimpleCov.start do
  add_filter '/config/'
  add_filter '/spec/'
  add_filter '/lib/workers/engage/constants'
end

SimpleCov.at_exit do
  SimpleCov.result.format!
  SimpleCov.minimum_coverage 100
end

Dir["#{ Broker.project_root }/lib/workers/*.rb",
    "#{ Broker.project_root }/config/initializers/*.rb",
    "#{ Broker.project_root }/spec/support/*.rb"].each { |file| require file }

Capybara.default_driver = :selenium

VCR.configure do |c|
  c.cassette_library_dir = './spec/cassettes'
  c.default_cassette_options = {:record => :none}
  c.hook_into :faraday
  c.configure_rspec_metadata!
  c.default_cassette_options = {match_requests_on: [:body]}

  c.ignore_localhost = true
  c.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Capybara::DSL

  # config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.color = true

  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  # --seed 1234
  config.order = 'random'

  cleaners = {}
  config.before(:suite) do
    # As we have more than one active sequel database, we have to specify the one to use manually!
    cleaners[:mdb] = DatabaseCleaner[:sequel, {:connection => Broker.database}]
    cleaners[:mdb].strategy = :transaction
    cleaners[:mdb].clean_with(:truncation)
  end

  config.before(:each) do
    Typhoeus::Expectation.clear
    cleaners[:mdb].start
    $stdout.stub(:write)  # Ignores puts commands
  end

  config.after(:each) do
    cleaners[:mdb].clean
  end

  config.filter_run_excluding :client_monitor => true
end
