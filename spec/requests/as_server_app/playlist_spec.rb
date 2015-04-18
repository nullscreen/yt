require 'spec_helper'
require 'yt/models/playlist'

describe Yt::Playlist, :server_app do
  subject(:playlist) { Yt::Playlist.new id: id }

  context 'given an existing playlist' do
    let(:id) { 'PLSWYkYzOrPMT9pJG5St5G0WDalhRzGkU4' }

    it 'returns valid snippet data' do
      expect(playlist.snippet).to be_a Yt::Snippet
      expect(playlist.title).to be_a String
      expect(playlist.description).to be_a Yt::Description
      expect(playlist.thumbnail_url).to be_a String
      expect(playlist.published_at).to be_a Time
      expect(playlist.tags).to be_an Array
      expect(playlist.channel_id).to be_a String
      expect(playlist.channel_title).to be_a String
    end

    it { expect(playlist.status).to be_a Yt::Status }
    it { expect(playlist.playlist_items).to be_a Yt::Collections::PlaylistItems }
    it { expect(playlist.playlist_items.first).to be_a Yt::PlaylistItem }
  end

  context 'given an unknown playlist' do
    let(:id) { 'not-a-playlist-id' }

    it { expect{playlist.snippet}.to raise_error Yt::Errors::NoItems }
    it { expect{playlist.status}.to raise_error Yt::Errors::NoItems }
  end
end