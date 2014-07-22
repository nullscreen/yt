require 'spec_helper'
require 'yt/models/playlist_item'

describe Yt::PlaylistItem, :device_app do
  subject(:item) { Yt::PlaylistItem.new id: id, auth: $account }

  context 'given an existing playlist item' do
    let(:id) { 'PLjW_GNR5Ir0GWEP_oveGBNjTvKkYyZfsna1TZDCBP-Z8' }

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
      expect(item.privacy_status).to be_in Yt::Status::PRIVACY_STATUSES
    end
  end

  context 'given an unknown playlist item' do
    let(:id) { 'not-a-playlist-item-id' }

    it { expect{item.snippet}.to raise_error Yt::Errors::RequestError }
  end
end