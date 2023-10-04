require 'spec_helper'
require 'yt/models/playlist_item'

describe Yt::PlaylistItem, :server_app, :vcr do
  subject(:item) { Yt::PlaylistItem.new id: id }

  context 'given an existing playlist item' do
    let(:id) { 'UExnbkRNdzZ4STVwbE9YYUtzNXpOREIzelJXWUVhOFppLS41NkI0NEY2RDEwNTU3Q0M2' }

    it 'returns valid snippet data' do
      expect(item.snippet).to be_a Yt::Snippet
      expect(item.title).to be_a String
      expect(item.description).to be_a String
      expect(item.thumbnail_url).to be_a String
      expect(item.published_at).to be_a Time
      expect(item.channel_id).to be_a String
      expect(item.channel_title).to be_a String
      expect(item.playlist_id).to be_a String
      expect(item.position).to be_an Integer
      expect(item.video_id).to be_a String
      expect(item.video).to be_a Yt::Models::Video
    end
  end

  context 'given an unknown playlist item' do
    let(:id) { 'not-a-playlist-item-id' }

    it { expect{item.snippet}.to raise_error Yt::Errors::RequestError }
  end
end
