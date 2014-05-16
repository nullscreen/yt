require 'spec_helper'
require 'yt/models/playlist'
require 'yt/collections/playlist_items'

describe Yt::Collections::PlaylistItems do
  subject(:collection) { Yt::Collections::PlaylistItems.new parent: playlist }
  let(:playlist) { Yt::Playlist.new }
  let(:attrs) { {id: 'MESycYJytkU', kind: :video} }
  let(:response_body) { %Q{{"error":{"errors":[{"reason":"#{reason}"}]}}} }
  let(:msg) { {response: {body: response_body}}.to_json }

  describe '#insert' do
    let(:playlist_item) { Yt::PlaylistItem.new }

    context 'given an existing video' do
      before { collection.stub(:do_insert).and_return playlist_item }

      it { expect(collection.insert attrs).to eq playlist_item }
    end

    context 'given an unknown video' do
      let(:reason) { 'videoNotFound' }
      before { collection.stub(:do_insert).and_raise Yt::Error, msg }

      it { expect{collection.insert attrs}.to fail.with 'videoNotFound' }
      it { expect{collection.insert attrs, ignore_errors: true}.not_to fail }
    end

    context 'given a forbidden video' do
      let(:reason) { 'forbidden' }
      before { collection.stub(:do_insert).and_raise Yt::Error, msg }

      it { expect{collection.insert attrs}.to fail.with 'forbidden' }
      it { expect{collection.insert attrs, ignore_errors: true}.not_to fail }
    end
  end

  describe '#delete_all' do
    before { collection.stub(:do_delete_all).and_return [true] }

    it { expect(collection.delete_all).to eq [true] }
  end
end