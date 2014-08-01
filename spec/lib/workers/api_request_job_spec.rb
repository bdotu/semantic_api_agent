require 'spec_helper'
require 'workers/api_request_job'
require './config/worker_init'

describe ApiRequestJob do
  before(:each) do
    @time = 'time'
    @data = 'data'
    @job_info = 'job_info'
  end  

  describe '#seed' do
    it 'should seed the data to be processed' do
      # ApiRequestJob.stub(:perform_in).and_return('passed!')
      ApiRequestJob.should_receive(:perform_in).twice
      ApiRequestJob.seed(@time, @data, nil)
      ApiRequestJob.seed(@time, nil, @job_info)
    end
  end

  describe '#perform' do
    before(:each) do
      ApiRequestJob.should_receive(:perform).once
    end
    context 'when job info is nil' do
      it 'gets the job info and seeds the data' do
        ApiRequestJob.new.perform(@data, nil)
      end
    end

    context 'when job info is not nil' do
      it 'raises a resend_flag and seeds the data' do
        ApiRequestJob.new.perform(@data, @job_info)
      end
    end
  end

  # describe '#send_data_to_ci' do
  #   it 'should send data to ci to be analyzed' do
  #     ApiRequestJob.should_receive(:send_data_to_ci).once
  #     ApiRequestJob.new.send_data_to_ci(@data)
  #   end
  # end

end