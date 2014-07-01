require './config/request_listener_init'

class RequestListener
  def self.process(payload)
    data = JSON.parse(payload)
    puts "Request received, will bounce a job to deal with API..."
    ApiRequestJob.perform_async(data, nil)
    :success
  end 
end