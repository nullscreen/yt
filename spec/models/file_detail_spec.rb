require 'spec_helper'
require 'yt/models/file_detail'

describe Yt::FileDetail do
  subject(:file_detail) { Yt::FileDetail.new data: data }

  describe '#data' do
    let(:data) { {"key"=>"value"} }
    specify 'returns the data the file detail was initialized with' do
      expect(file_detail.data).to eq data
    end
  end

  describe '#file_size' do
    context 'given a video with fileSize' do
      let(:data) { {"fileSize"=>"8000000"} }
      it { expect(file_detail.file_size).to be 8_000_000 }
    end
  end

  describe '#file_type' do
    context 'given a video with fileType' do
      let(:data) { {"fileType"=>"video"} }
      it { expect(file_detail.file_type).to eq 'video' }
    end
  end

  describe '#container' do
    context 'given a video with container' do
      let(:data) { {"container"=>"mov"} }
      it { expect(file_detail.container).to eq 'mov' }
    end
  end
end
