require 'spec_helper'
require 'yt/collections/live_broadcasts'
require 'yt/models/live_broadcast'

describe Yt::Collections::LiveBroadcasts do
  subject(:collection) { Yt::Collections::LiveBroadcasts.new }
  before { expect(collection).to behave }

  describe '#insert' do
    let(:live_broadcast) { Yt::LiveBroadcast.new }
    # TODO: separate stubs to show options translate into do_insert params
    let(:behave) { receive(:do_insert).and_return live_broadcast }

    it { expect(collection.insert).to eq live_broadcast }
  end
end
