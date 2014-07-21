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
      "channel_id" => 1000,
      "channel_type" => "Facebook",
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
        {"id"=> "022","text"=> "bullshit Oracle"},
        {"id"=> "023","text"=> "back off Oracle!!!"},
        {"id"=> "024","text"=> "What is Oracle>????"},
        {"id"=> "025","text"=> "I hate Oracle!!!"},
        {"id"=> "026","text"=> "I don't like no-sql database"},
        {"id"=> "027","text"=> "Wanna join Oracle???"},
        {"id"=> "028","text"=> "Oracle or IBM?"},
        {"id"=> "029","text"=> "get this coupon for free!"},
        {"id"=> "030","text"=> "Oracle database on sale! database database"},
        {"id"=> "031","text"=> "What did you eat for breakfast??"},
        {"id"=> "032","text"=> "I love Oracle Cloud!"},
        {"id"=> "033","text"=> "I love Oracle!!!! Oracle Oracle Oracle"},
        {"id"=> "034","text"=> "database management"},
        {"id"=> "035","text"=> "Oracle rocks"},
        {"id"=> "036","text"=> "Google, Oracle, Facebook. Choose one??"},
        {"id"=> "037","text"=> "Oracle"},
        {"id"=> "038","text"=> "The oracle campus is pretty cool"},
        {"id"=> "039","text"=> "but not as much as Google"},
        {"id"=> "040","text"=> "true"},
        {"id"=> "041","text"=> "who wants to be a millionaire?"},
        {"id"=> "042","text"=> "All is fair in love and war"},
        {"id"=> "043","text"=> "Bill Gates, Larry Ellison, Larry Page and Sergey Brin are some of the great minds in tech."},
        {"id"=> "044","text"=> "Silicon Valley"},
        {"id"=> "045","text"=> "Betas"},
        {"id"=> "046","text"=> "Slum dog millionaire"},
        {"id"=> "047","text"=> "3 idiots"},
        {"id"=> "048","text"=> "Some day, some time, some way, some how"},
        {"id"=> "049","text"=> "veni vidi vici"},
        {"id"=> "050","text"=> "no shit"},
        {"id"=> "051","text"=> "you damn right am cool"},
        {"id"=> "052","text"=> "I hate subpoenas"},
        {"id"=> "053","text"=> "cold rush"},
        {"id"=> "054","text"=> "fuck yeah!!!!!"},
        {"id"=> "055","text"=> "hate to do this"},
        {"id"=> "056","text"=> "hell no"},
        {"id"=> "057","text"=> "to be or not to be"},
        {"id"=> "058","text"=> "that is the question"},
        {"id"=> "059","text"=> "database database database"},
        {"id"=> "060","text"=> "I don't like no-sql database"},
        {"id"=> "061","text"=> "stubborn"},
        {"id"=> "062","text"=> "Oracle, IBM, Intel, Facebook or Google?"},
        {"id"=> "063","text"=> "cloud computing"},
        {"id"=> "064","text"=> "fire drill exercises"},
        {"id"=> "065","text"=> "am I wrong???"},
        {"id"=> "066","text"=> "love is the answer"},
        {"id"=> "067","text"=> "In her eyes"},
        {"id"=> "068","text"=> "american eagle"},
        {"id"=> "069","text"=> "This is a topic about american eagle."},
        {"id"=> "070","text"=> "This is a topic."},
        {"id"=> "071","text"=> "switching costs are usually high for businesses"},
        {"id"=> "072","text"=> "Germany is definitely going to win this world cup"},
        {"id"=> "073","text"=> "Framers market"},
        {"id"=> "074","text"=> "O my God!! what did you say??"},
        {"id"=> "075","text"=> "What do you think about machine learning??"},
        {"id"=> "076","text"=> "Ready or not, here I come"},
        {"id"=> "077","text"=> "Every move I make....every srtep I take"},
        {"id"=> "078","text"=> "I'll be missing you"},
        {"id"=> "079","text"=> "We really need to work on this recommendation algorithm"},
        {"id"=> "080","text"=> "I can probably use the Google predict API"},
        {"id"=> "081","text"=> "Why doesn't Oracle have any open source API? Or dop they?"},
        {"id"=> "082","text"=> "I came, I saw, I conquered"},
        {"id"=> "083","text"=> "This is a topic about american eagle. Isn't it great?!?"},
        {"id"=> "084","text"=> "This is a topic about american eagle. Isn't it great?!?"},
        {"id"=> "085","text"=> "Things will never be the same"},
        {"id"=> "086","text"=> "Naruto or Sasuke??"},
        {"id"=> "087","text"=> "We are a team,that is what we do."},
        {"id"=> "088","text"=> "The truncate optimization."},
        {"id"=> "089","text"=> "This is a topic about american eagle. Isn't it great?!?"},
        {"id"=> "090","text"=> "This is a topic about american eagle. Isn't it great?!?"},
        {"id"=> "091","text"=> "This is a topic about american eagle. Isn't it great?!?"},
        {"id"=> "092","text"=> "I'm the best!"},
        {"id"=> "093","text"=> "he is the best at the game"},
        {"id"=> "094","text"=> "The law of diminishing intent"},
        {"id"=> "095","text"=> "The law of simultaneous discovery"},
        {"id"=> "096","text"=> "The art of war by Sun Tzu"},
        {"id"=> "097","text"=> "Mind games"},
        {"id"=> "098","text"=> "Are you living in a computer simulation?"},
        {"id"=> "099","text"=> "Empty your mind. Be formless, shapeless, like water."},
        {"id"=> "100","text"=> "Now you put water into a cup, it becomes a cup."},
        {"id"=> "101","text"=> "You put water into a bottle, it becomes a bottle."},
        {"id"=> "102","text"=> "You put water into a teapot, it becomes the teapot."},
        {"id"=> "103","text"=> "Water can flow, creep, drip or crash."},
        {"id"=> "104","text"=> "Be water my friend."},
        {"id"=> "105","text"=> "Bruce Lee!!!"}
      ],
      "enrichments" => [
        "top_terms"
        # "theming"
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