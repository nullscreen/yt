require 'spec_helper'
require 'yt/associations/playlist_items'

describe Yt::Associations::PlaylistItems, scenario: :device_app do
  before :all do
    account = Yt.configuration.account
    @playlist = account.create_playlist title: "Yt Test Playlist Items"
   end
  after(:all) { @playlist.delete }

  describe '#playlist_items' do
    let(:video_id) { 'MESycYJytkU' }
    before { @playlist.add_video video_id }
    # TODO: after, delete playlist item

    it { expect(@playlist.playlist_items.count).to be > 0 }
    it { require 'pry'; binding.pry; true; expect(@playlist.playlist_items.first).to be_a Yt::PlaylistItem }
  end

  describe '#add_video' do
    let(:video_id) { 'MESycYJytkU' }
    # TODO: after, delete playlist item
    it { expect(@playlist.add_video video_id).to be_a Yt::PlaylistItem }
    it { expect{@playlist.add_video video_id}.to change{@playlist.playlist_items.count}.by(1) }
  end

  describe '#add_videos' do
    let(:video_ids) { ['MESycYJytkU'] * 2 }
    # TODO: after, delete playlist items
    it { expect(@playlist.add_videos video_ids).to have(2).items }
    it { expect{@playlist.add_videos video_ids}.to change{@playlist.playlist_items.count}.by(2) }
  end


  describe '#delete_playlist_items' do
    let(:video_id) { 'MESycYJytkU' }
    before { @playlist.add_video video_id }

    it { expect(@playlist.delete_playlist_items).to eq [true] }
    it { expect{@playlist.delete_playlist_items}.to change{@playlist.playlist_items.count}.by(-1) }
  end
end