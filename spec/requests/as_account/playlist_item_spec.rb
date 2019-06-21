require 'spec_helper'
require 'yt/models/playlist_item'

describe Yt::PlaylistItem, :device_app do
  subject(:item) { Yt::PlaylistItem.new id: id, auth: $account }

  context 'given an existing playlist item' do
    let(:id) { 'UExiai1JRGU2Zzh2c0FQT0RFci1xRUZjRERvWHhqRzhEVC41MjE1MkI0OTQ2QzJGNzNG' }

    it 'returns valid metadata' do
      expect(item.title).to be_a String
      expect(item.description).to be_a String
      expect(item.thumbnail_url).to be_a String
      expect(item.published_at).to be_a Time
      expect(item.channel_id).to be_a String
      expect(item.channel_title).to be_a String
      expect(item.playlist_id).to be_a String
      expect(item.position).to be_an Integer
      expect(item.video_id).to be_a String
      expect(item.video).to be_a Yt::Video
      expect(item.privacy_status).to be_a String
    end
  end

  context 'given an unknown playlist item' do
    let(:id) { 'not-a-playlist-item-id' }

    it { expect{item.snippet}.to raise_error Yt::Errors::RequestError }
  end

  context 'given one of my own playlist items that I want to update', rate_limited: true do
    before(:all) do
      @my_playlist = $account.create_playlist title: "Yt Test Update Playlist Item #{rand}"
      @my_playlist.add_video '9bZkp7q19f0'
      @my_playlist_item = @my_playlist.add_video '9bZkp7q19f0'
    end
    after(:all) { @my_playlist.delete }

    let(:id) { @my_playlist_item.id }
    let!(:old_title) { @my_playlist_item.title }
    let!(:old_privacy_status) { @my_playlist_item.privacy_status }
    let(:update) { @my_playlist_item.update attrs }

    context 'given I update the position' do
      let(:attrs) { {position: 0} }

      specify 'only updates the position' do
        expect(update).to be true
        expect(@my_playlist_item.position).to be 0
        expect(@my_playlist_item.title).to eq old_title
        expect(@my_playlist_item.privacy_status).to eq old_privacy_status
      end
    end
  end
end
