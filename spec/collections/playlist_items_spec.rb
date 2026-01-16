require 'spec_helper'
require 'yt/models/playlist'
require 'yt/models/playlist_item'
require 'yt/collections/playlist_items'

describe Yt::Collections::PlaylistItems do
  subject(:collection) { Yt::Collections::PlaylistItems.new parent: playlist }
  let(:playlist) { Yt::Playlist.new id: 'LLxO1tY8h1AhOz0T4ENwmpow' }
  let(:attrs) { {id: '9bZkp7q19f0', kind: :video} }
  let(:msg) { {response_body: {error: {errors: [{reason: reason}]}}}.to_json }
  before { expect(collection).to behave }

  describe '#insert' do
    let(:playlist_item) { Yt::PlaylistItem.new }

    context 'given an existing video' do
      let(:behave) { receive(:do_insert).and_return playlist_item }

      it { expect(collection.insert attrs).to eq playlist_item }
    end

    context 'given an unknown video' do
      let(:reason) { 'videoNotFound' }
      let(:behave) { receive(:do_insert).and_raise Yt::Error, msg }

      it { expect{collection.insert attrs}.to fail.with 'videoNotFound' }
      it { expect{collection.insert attrs, ignore_errors: true}.not_to fail }
    end

    context 'given a forbidden video' do
      let(:reason) { 'forbidden' }
      let(:behave) { receive(:do_insert).and_raise Yt::Error, msg }

      it { expect{collection.insert attrs}.to fail.with 'forbidden' }
      it { expect{collection.insert attrs, ignore_errors: true}.not_to fail }
    end
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
