require 'yaml'
require 'event-subscriber'
require './config/initializers/sidekiq'
require './lib/workers/request_listener'
require 'bunny'

namespace :subscriber do
  desc "Start listening to the request queue..."
  task :start_request_listener do
    EventSubscriber.new(:request_listener).start!(RequestListener)
  end

  desc "Stop listening to the request queue..."
  task :stop_request_listener do
    EventSubscriber.new(:request_listener).stop!
    clean_pid YAML.load_file('config/event_subscriber.yml')[RACK_ENV]['request_listener']['pidfile']
  end

  desc "Purge the events queue"
  task :purge do
    EventSubscriber.new(:request_listener).purge!
  end

  desc "Sending messages for testing..."
  task :send_sample_data do
    data = {
      "caller" => "Engage",
      "request_id" => "88888",
      "customerId" => 6357,
      "documents" => [
        {"id"=> "000","text"=> "Who loves Oracle?!?"},
        {"id"=> "001","text"=> "Best database in the world, Oracle?!?"},
        {"id"=> "002","text"=> "OracleCloud!"},
        {"id"=> "003","text"=> "Oracle Red"},
        {"id"=> "004","text"=> "wow the Oracle American Sailing boat is cool"},
        {"id"=> "005","text"=> "repost?!?"},
        {"id"=> "006","text"=> "Oracle database is too expensive!"},
        {"id"=> "007","text"=> "what do you want"},
        {"id"=> "008","text"=> "Love is blind"},
        {"id"=> "009","text"=> "hard working"},
        {"id"=> "010","text"=> "get this coupon, 2 for 1"},
        {"id"=> "011","text"=> "sleepy..."},
        {"id"=> "012","text"=> "sounds cool"},
        {"id"=> "013","text"=> "oracle go!"},
        {"id"=> "014","text"=> "hehe"},
        {"id"=> "015","text"=> "wtf"},
        {"id"=> "016","text"=> "dislike you"},
        {"id"=> "017","text"=> "like you"},
        {"id"=> "018","text"=> "what???"},
        {"id"=> "019","text"=> "yeah"},
        {"id"=> "020","text"=> "oracle yeah!!!!!"},
        {"id"=> "021","text"=> "hate to do this"},
        {"id"=> "059","text"=> "bullshit Oracle"},
        {"id"=> "060","text"=> "back off Oracle!!!"},
        {"id"=> "061","text"=> "What is Oracle>????"},
        {"id"=> "062","text"=> "I hate Oracle!!!"},
        {"id"=> "063","text"=> "I don't like no-sql database"},
        {"id"=> "064","text"=> "Wanna join Oracle???"},
        {"id"=> "065","text"=> "Oracle or IBM?"},
        {"id"=> "066","text"=> "get this coupon for free!"},
        {"id"=> "067","text"=> "Oracle database on sale! database database"},
        {"id"=> "068","text"=> "What did you eat for breakfast??"},
        {"id"=> "069","text"=> "I love Oracle Cloud!"},
        {"id"=> "070","text"=> "I love Oracle!!!! Oracle Oracle Oracle"}
      ],
      "enrichments" => [
        "top_terms"
      ]
    }

    conn = Bunny.new($rabbitmq_config)
    conn.start
    ch = conn.create_channel
    x = ch.exchange($rabbitmq_config[:exchange_name], type: 'fanout', durable: true)
    x.publish(data.to_json)
    conn.close
  end

  task :test_broadcast do
    conn = Bunny.new($rabbitmq_config)
    conn.start
    ch = conn.create_channel
    x = ch.exchange($rabbitmq_config[:broadcast_pool], type: 'fanout', durable: true)
    x.publish({ 'greetings' => 'Hello World!' }.to_json)
    conn.close
  end
end