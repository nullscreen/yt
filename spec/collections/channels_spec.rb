require 'spec_helper'
require 'yt/collections/channels'

describe Yt::Collections::Channels do
  subject(:collection) { Yt::Collections::Channels.new }

  describe '#etag' do
    let(:etag) { 'etag123' }

    before do
      expect_any_instance_of(Yt::Request).to receive(:run).once do
        double(body: {'etag'=> etag, 'items'=> [], 'pageInfo'=> {'totalResults'=>0}})
      end
    end

    it 'returns the etag from the list response' do
      expect(collection.etag).to eq etag
    end
  end
end
