require './lib/workers/api_request_job'

module Sinatra
  module KeyTermsHelper
    # Get top n terms from db based on frequency
    def top_terms(n, channel_type, channel_id)
      count = KeyTerm.where(:channel_type => channel_type, :channel_id => channel_id).count
      if count > 0 && count < n.to_i
        return []
      elsif count == 0
        return "No such channel_type and channel_id in the database"
      else
        ds = KeyTerm.where(:channel_type => channel_type, :channel_id => channel_id).order(Sequel.desc(:count))
        ds.limit(n.to_i)
      end
    end

  end

  helpers KeyTermsHelper
end