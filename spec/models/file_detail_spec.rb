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
end
