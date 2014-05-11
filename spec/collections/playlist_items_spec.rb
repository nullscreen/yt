require 'spec_helper'
require 'yt/models/playlist'
require 'yt/collections/playlist_items'

describe Yt::Collections::PlaylistItems do
  subject(:collection) { Yt::Collections::PlaylistItems.new parent: playlist }
  let(:playlist) { Yt::Playlist.new }

  describe '#insert' do
    let(:playlist_item) { Yt::PlaylistItem.new }
    # TODO: separate stubs to show options translate into do_insert params
    before { collection.stub(:do_insert).and_return playlist_item }

    it { expect(collection.insert).to eq playlist_item }
  end


  describe '#delete_all' do
    before { collection.stub(:do_delete_all).and_return [true] }

    it { expect(collection.delete_all).to eq [true] }
  end
end