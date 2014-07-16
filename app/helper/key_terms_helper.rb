require './lib/workers/api_request_job'

module Sinatra
	module KeyTermsHelper
		# Get top n terms from db based on frequency
  		def top_terms(n)
    		count = KeyTerm.count
    		# puts count
    		if count < n.to_i
      			KeyTerm.group(:id).having('id <= ?', count).all.inspect
      			#return "Table contains only #{count} entries"
    		else
      			KeyTerm.group(:id).having('id <= ?', n.to_i).all.inspect
    		end
  		end
	end

	helpers KeyTermsHelper
end