# DB rake tasks for the development environment.
# To run these for the test environment, run these with RACK_ENV as test.
# e.g. $ bundle exec rake db:migrate RACK_ENV='test'
require './config/initializer'

namespace :db do
  @test_accounts = YAML.load_file("#{ Broker.project_root }/config/test.yml")

  task :migrate do
    db_migrate
  end

  task :drop do
    db_drop
  end

  task :reset => [:drop, :migrate] do
  end

  task :seed do
    db_seed
  end

  task :wipe do
    db_wipe
  end

  # You might have to do this if your database gets desycned.
  # An example might be if you work on branches at different migration levels.
  task :restore do
    db_wipe
    db_migrate
  end

  private

  def db_migrate
    case RACK_ENV
    when 'test'
      `sequel -m db/migrations sqlite://db/test.db`
    when 'development'
      `sequel -m db/migrations sqlite://db/development.db`
    else
      db_config = YAML.load_file('config/database.yml')[RACK_ENV]
      exec "bundle exec sequel -m db/migrations #{ db_config['adapter'] }://#{ db_config['username'] }:#{ db_config['password'] }" +
             "@#{ db_config['host'] }:#{ db_config['port'] }/#{ db_config['database'] } -E"
    end
  end

  def db_drop
    case RACK_ENV
    when 'test'
      `sequel -m db/migrations -M 0 sqlite://db/test.db`
    when 'development'
      `sequel -m db/migrations -M 0 sqlite://db/development.db`
    else
      puts "Don't know how to drop DB in environment #{ENV['RACK_ENV']}."
    end
  end

  def db_seed
    @test_accounts.each do |account|
      Resource.insert(identifier: account['identifier'],
                      access_token: account['access_token'],
                      read_token: account['access_token'],
                      is_alive: true,
                      is_read_alive: true)
    end
  end

  def db_wipe
    tables = Broker.database.tables
    tables.each do |table|
      Broker.database.drop_table(table)
    end
  end
end
