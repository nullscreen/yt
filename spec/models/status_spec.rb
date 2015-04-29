require 'spec_helper'
require 'yt/models/status'

describe Yt::Status do
  subject(:status) { Yt::Status.new data: data }

  describe '#data' do
    let(:data) { {"key"=>"value"} }
    specify 'returns the data the status was initialized with' do
      expect(status.data).to eq data
    end
  end
end