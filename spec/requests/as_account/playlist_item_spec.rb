require 'spec_helper'
require 'yt/models/playlist_item'

describe Yt::PlaylistItem, :device_app, :vcr do
  subject(:item) { Yt::PlaylistItem.new id: id, auth: test_account }

  context 'given an existing playlist item' do
    let(:id) { 'UExiai1JRGU2Zzh2dGF4MVNha0xFd09kT0V2LW52aml5MC41NkI0NEY2RDEwNTU3Q0M2' }

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

  context 'given one of my own playlist items that I want to update' do
    let(:id) { 'UExiai1JRGU2Zzh2dGF4MVNha0xFd09kT0V2LW52aml5MC41NkI0NEY2RDEwNTU3Q0M2' }
    let!(:old_title) { item.title }
    let!(:old_privacy_status) { item.privacy_status }
    let(:update) { item.update attrs }

    context 'given I update the position' do
      let(:attrs) { {position: 0} }

      specify 'only updates the position' do
        expect(update).to be true
        expect(item.position).to be 0
        expect(item.title).to eq old_title
        expect(item.privacy_status).to eq old_privacy_status
      end
    end
  end
end
