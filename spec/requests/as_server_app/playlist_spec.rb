require 'spec_helper'
require 'yt/models/playlist'

describe Yt::Playlist, :server_app do
  subject(:playlist) { Yt::Playlist.new attrs }

  context 'given an existing playlist ID' do
    let(:attrs) { {id: 'PLSWYkYzOrPMT9pJG5St5G0WDalhRzGkU4'} }

    it 'returns valid snippet data' do
      expect(playlist.snippet).to be_a Yt::Snippet
      expect(playlist.title).to be_a String
      expect(playlist.description).to be_a Yt::Description
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

  context 'given an existing playlist URL' do
    let(:attrs) { {url: 'https://www.youtube.com/playlist?list=LLxO1tY8h1AhOz0T4ENwmpow'} }

    specify 'provides access to its data' do
      expect(playlist.id).to eq 'LLxO1tY8h1AhOz0T4ENwmpow'
      expect(playlist.title).to eq 'Liked videos'
      expect(playlist.privacy_status).to eq 'public'
    end
  end

  context 'given an unknown playlist' do
    let(:attrs) { {id: 'not-a-playlist-id'} }

    it { expect{playlist.snippet}.to raise_error Yt::Errors::NoItems }
    it { expect{playlist.status}.to raise_error Yt::Errors::NoItems }
  end


  context 'given an unknown playlist URL' do
    let(:attrs) { {url: 'youtube.com/--not-a-valid-url--'} }

    specify 'accessing its data raises an error' do
      expect{playlist.id}.to raise_error Yt::Errors::NoItems
      expect{playlist.title}.to raise_error Yt::Errors::NoItems
      expect{playlist.status}.to raise_error Yt::Errors::NoItems
    end
  end
end