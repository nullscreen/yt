require 'spec_helper'
require 'yt/models/playlist'

describe Yt::Playlist, :server_app, :vcr do
  subject(:playlist) { Yt::Playlist.new attrs }

  context 'given an existing playlist ID' do
    let(:attrs) { {id: 'PLpjK416fmKwQ6Ene4GKRLICznoE1QFyt4'} }

    it 'returns valid snippet data' do
      expect(playlist.snippet).to be_a Yt::Snippet
      expect(playlist.title).to be_a String
      expect(playlist.description).to be_a String
      expect(playlist.thumbnail_url).to be_a String
      expect(playlist.published_at).to be_a Time
      expect(playlist.tags).to be_an Array
      expect(playlist.channel_id).to be_a String
      expect(playlist.channel_title).to be_a String
      expect(playlist.item_count).to be_an Integer
    end

    it { expect(playlist.status).to be_a Yt::Status }
    it { expect(playlist.playlist_items).to be_a Yt::Collections::PlaylistItems }
    it { expect(playlist.playlist_items.first).to be_a Yt::PlaylistItem }
  end
end
