require './config/worker_init'
require './config/sequel'

class DBManagementJob
  include Sidekiq::Worker
  sidekiq_options queue: :db_management_queue

  def perform
    # Job to delete old data goes here
  end

end