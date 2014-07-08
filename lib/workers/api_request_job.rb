require './config/worker_init'
require './config/sequel'
require 'sequel'

class ApiRequestJob
  include Sidekiq::Worker
  sidekiq_options queue: :api_request_queue

  # def self.lock(job_id)
  #   "lock:#{job_id}"
  # end

  # def self.unlock!(job_id)
  #   lock = self.lock(job_id)
  #   Sidekiq.redis { |conn| conn.del(lock) }
  # end
  
# String :term
#       String :frequency
#       String :account_id
#       String :channel_type

  def test
    KeyTerm.insert({
      term: "abc",
      frequency: "123",
      account_id: "11",
      channel_type: "fb"
      })
    puts KeyTerm.where({term:"abc"}).all.inspect

  end

  def self.seed(time, data, job_info)
    if job_info.nil?
      perform_in(time, data, nil)
    else
      perform_in(time, nil, job_info)
    end
  end

  def perform(data, job_info)
    unless data.nil?
      puts "----------------DATA RECEIVED----------------"
      puts "#{data}"
      puts "---------------------------------------------"
    end
    #self.class.unlock!
    if job_info.nil?
      job_info = send_data_to_ci(data)
      self.class.seed(Broker.network_settings['job_interval'], nil, job_info)
    else
      resend_flag = get_analysis_from_ci(job_info)
      if resend_flag
        job_info['counter'] += 1 
        self.class.seed(Broker.network_settings['job_interval'], nil, job_info)
      end
    end
  end

  def send_data_to_ci(data)
    response = Typhoeus::Request.post(
      "#{Broker.network_settings['ci_endpoint']}v1/analyticsJobs",
      method: :post,
      body: data.to_json,
      userpwd: "#{Broker.network_settings['user']}:#{Broker.network_settings['pwd']}",
      headers: { 'Content-Type' => "application/json" }
    )

    job_info = JSON.parse(response.response_body)
    job_info.merge!(
      'caller' => data['caller'],
      'request_id' => data['request_id'],
      'counter' => 0
    )

    puts "sending to CI....."
    puts "------------------JOB INFO-------------------"
    puts job_info.inspect
    puts "---------------------------------------------"

    return nil if job_info['id'].nil?
    job_info
  end

  def get_analysis_from_ci(job_info)
    puts "Fetch count: #{job_info['counter']}"

    if job_info['counter'] == Broker.network_settings['counter_upperbound']
      analysis = {
        'id' => job_info['id'],
        'status' => 'failed',
        'caller' => job_info['caller'],
        'request_id' => job_info['request_id']
      }
      push_analysis_back(analysis)
      return false
    end

    response = Typhoeus::Request.get(
      "#{Broker.network_settings['ci_endpoint']}v1/analyticsJobs/#{job_info['id']}",
      userpwd: "#{Broker.network_settings['user']}:#{Broker.network_settings['pwd']}",
      headers: { 'Content-Type' => "application/json"}
    )

    analysis = JSON.parse(response.response_body)

    puts "-------------ANALYSIS INFO-------------"
    puts analysis.inspect

    case analysis['status']
    when 'pending'
      return true
    when 'completed'
      # analysis.merge!(
      #   'caller' => job_info['caller'],
      #   'request_id' => job_info['request_id']
      # )
      # push_analysis_back(analysis)

      #TODO:
      #store the analysis into database

      # db = SQLITE3::Database.new "development.db"

      # analysis['topTerms'].each do |item|
      #   db.execute ( "INSERT INTO key_terms (id, term, frequency, account_id, channel_type) 
      #     VALUES (0, #{item[term]}, #{item[count]}, #{item[id]}, null)" )
      # end

      # db = Sequel.sqlite('development.db')
      # db.run "CREATE TABLE users (name VARCHAR(255) NOT NULL, age INT(3) NOT NULL)"

     #  KeyTerm.insert({
     #    term: "def",
     #    frequency: "100",
     #    account_id: "0011",
     #    channel_type: "fb"         
     #  })
     # puts KeyTerm.where({term:"def"}).all.inspect

      return false
    end
  end

  def push_analysis_back(analysis)
    conn = Bunny.new($rabbitmq_config)
    conn.start
    ch = conn.create_channel
    x = ch.exchange($rabbitmq_config[:broadcast_pool], type: 'fanout', durable: true)
    x.publish(analysis.to_json)
    conn.close
  end
end