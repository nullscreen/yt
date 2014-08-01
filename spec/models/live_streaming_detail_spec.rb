require 'spec_helper'
require 'yt/models/live_streaming_detail'

describe Yt::LiveStreamingDetail do
  subject(:live_streaming_detail) { Yt::LiveStreamingDetail.new data: data }

  describe '#actual_start_time' do
    context 'given a non-live streaming video' do
      let(:data) { {} }
      it { expect(live_streaming_detail.actual_start_time).to be_nil }
    end

    context 'given a live streaming video that has not started yet' do
      let(:data) { {"scheduledStartTime"=>"2017-07-10T00:00:00.000Z"} }
      it { expect(live_streaming_detail.actual_start_time).to be_nil }
    end

    context 'given a live streaming video that has started' do
      let(:data) { {"actualStartTime"=>"2014-08-01T17:48:40.678Z"} }
      it { expect(live_streaming_detail.actual_start_time.year).to be 2014 }
    end
  end

  describe '#actual_end_time' do
    context 'given a non-live streaming video' do
      let(:data) { {} }
      it { expect(live_streaming_detail.actual_end_time).to be_nil }
    end

    context 'given a live streaming video that has not ended yet' do
      let(:data) { {"scheduledStartTime"=>"2017-07-10T00:00:00.000Z"} }
      it { expect(live_streaming_detail.actual_end_time).to be_nil }
    end

    context 'given a live streaming video that has ended' do
      let(:data) { {"actualEndTime"=>"2014-08-01T17:48:40.678Z"} }
      it { expect(live_streaming_detail.actual_end_time.year).to be 2014 }
    end
  end

  describe '#scheduled_start_time' do
    context 'given a non-live streaming video' do
      let(:data) { {} }
      it { expect(live_streaming_detail.scheduled_start_time).to be_nil }
    end

    context 'given a live streaming video' do
      let(:data) { {"scheduledStartTime"=>"2017-07-10T00:00:00.000Z"} }
      it { expect(live_streaming_detail.scheduled_start_time.year).to be 2017 }
    end
  end

  describe '#scheduled_end_time' do
    context 'given a non-live streaming video' do
      let(:data) { {} }
      it { expect(live_streaming_detail.scheduled_end_time).to be_nil }
    end

    context 'given a live streaming video that broadcasts indefinitely' do
      let(:data) { {"scheduledStartTime"=>"2017-07-10T00:00:00.000Z"} }
      it { expect(live_streaming_detail.scheduled_end_time).to be_nil }
    end

    context 'given a live streaming video with a scheduled ednd' do
      let(:data) { {"scheduledEndTime"=>"2014-08-01T17:48:40.678Z"} }
      it { expect(live_streaming_detail.scheduled_end_time.year).to be 2014 }
    end
  end

  describe '#concurrent_viewers' do
    context 'given a non-live streaming video' do
      let(:data) { {} }
      it { expect(live_streaming_detail.concurrent_viewers).to be_nil }
    end

    context 'given a current live streaming video with viewers' do
      let(:data) { {"concurrentViewers"=>"1"} }
      it { expect(live_streaming_detail.concurrent_viewers).to be 1 }
    end

    context 'given a past live streaming video' do
      let(:data) { {"actualEndTime"=>"2013-08-01T17:48:40.678Z"} }
      it { expect(live_streaming_detail.concurrent_viewers).to be_nil }
    end
  end
end
