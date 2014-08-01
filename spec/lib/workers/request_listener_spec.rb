require 'spec_helper'
require 'workers/request_listener'

describe RequestListener do
  let(:data) do
    {}
  end

  describe "#process" do
    it "should update resource table and when receiving a message" do
      # ApiRequestJob.stub(:perform_async).and_return('bingo!')
      ApiRequestJob.should_receive(:perform_async).exactly(1).times
      RequestListener.process(data.to_json)
    end
  end
end