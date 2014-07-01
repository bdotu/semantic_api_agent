require 'yaml'
require './config/initializers/sidekiq'

namespace :invoke_api do
  namespace :sidekiq do
    task :start do
      pidfile = $sidekiq_settings['semantic_api_agent']['pidfile']
      logfile = $sidekiq_settings['semantic_api_agent']['logfile']
      errlog = $sidekiq_settings['semantic_api_agent']['errlog']
      puts "sidekiq -q api_request_queue -r ./lib/workers/workers_entrypoint.rb"
    end

    task :test do
      #Workers::ApiRequestJob.perform_in(2, "dad!!!a")
      puts "#{$project_root}"
      #ApiRequestJob.perform_async("you!!!")
    end
  end
end