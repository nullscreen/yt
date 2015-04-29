require 'spec_helper'
require 'yt/models/snippet'

describe Yt::Snippet do
  subject(:snippet) { Yt::Snippet.new data: data }

  describe '#data' do
    let(:data) { {"key"=>"value"} }
    specify 'returns the data the snippet was initialized with' do
      expect(snippet.data).to eq data
    end
  end
end
