require 'spec_helper'
require 'yt/models/content_detail'

describe Yt::ContentDetail do
  subject(:content_detail) { Yt::ContentDetail.new data: data }

  describe '#data' do
    let(:data) { {"key"=>"value"} }
    specify 'returns the data the content detail was initialized with' do
      expect(content_detail.data).to eq data
    end
  end

  describe '#duration' do
    context 'given a content_detail with duration in weeks, days, hours, minutes' do
      let(:data) { {"duration"=>"P1W2DT6H21M32S"}}
      it { expect(content_detail.duration).to eq 800492 }
    end

    context 'given a content_detail with duration in days' do
      let(:data) { {"duration"=>"P1D"}}
      it { expect(content_detail.duration).to eq 86400 }
    end

    context 'given a content_detail with duration in hours, minutes, seconds' do
      let(:data) { {"duration"=>"PT1H18M52S"} }
      it { expect(content_detail.duration).to eq 4732 }
    end

    context 'given a content_detail with duration in minutes and seconds' do
      let(:data) { {"duration"=>"PT2M51S"} }
      it { expect(content_detail.duration).to eq 171 }
    end

    context 'given a content_detail with duration in minutes' do
      let(:data) { {"duration"=>"PT2M"} }
      it { expect(content_detail.duration).to eq 120 }
    end

    context 'given a content_detail with duration in seconds' do
      let(:data) { {"duration"=>"PT51S"} }
      it { expect(content_detail.duration).to eq 51 }
    end
  end
end