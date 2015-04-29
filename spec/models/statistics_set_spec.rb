require 'spec_helper'
require 'yt/models/statistics_set'

describe Yt::StatisticsSet do
  subject(:statistics_set) { Yt::StatisticsSet.new data: data }

  describe '#data' do
    let(:data) { {"key"=>"value"} }
    specify 'returns the data the statistics set was initialized with' do
      expect(statistics_set.data).to eq data
    end
  end
end
