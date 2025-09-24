require 'spec_helper'
require 'yt/collections/playlists'

describe Yt::Collections::Playlists do
  subject(:collection) { Yt::Collections::Playlists.new }
  before { expect(collection).to behave }

  describe '#insert' do
    let(:playlist) { Yt::Playlist.new }
    # TODO: separate stubs to show options translate into do_insert params
    let(:behave) { receive(:do_insert).and_return playlist }

    it { expect(collection.insert).to eq playlist }
  end

  describe '#delete_all' do
    let(:behave) { receive(:do_delete_all).and_return [true] }

    it { expect(collection.delete_all).to eq [true] }
  end

  describe '#delete_all' do
    let(:behave) { receive(:do_delete_all).and_return [true] }

    it { expect(collection.delete_all).to eq [true] }
  end

  describe '#etag' do
    let(:etag) { 'etag123' }
    let(:behave) { receive(:fetch_etag).and_call_original }

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
