require 'spec_helper'
require 'yt/models/processing_detail'

describe Yt::ProcessingDetail do
  subject(:processing_detail) { Yt::ProcessingDetail.new data: data }

  describe '#data' do
    let(:data) { {"key"=>"value"} }
    specify 'returns the data the processing detail was initialized with' do
      expect(processing_detail.data).to eq data
    end
  end

  describe '#processing_status' do
    context 'given the processing_status' do
      let(:data) { {"processingStatus"=>"processing"} }
      it { expect(processing_detail.processing_status).to eq 'processing' }
    end
  end
end
