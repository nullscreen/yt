require 'spec_helper'
require 'yt/associations/playlist_items'

# TODO: Delete playlist item after tests that create them

describe Yt::Associations::PlaylistItems, scenario: :device_app do
  before :all do
    account = Yt.configuration.account
    @playlist = account.create_playlist title: "Yt Test Playlist Items"
   end
  after(:all) { @playlist.delete }

  describe '#playlist_items' do
    let(:video_id) { 'MESycYJytkU' }
    before { @playlist.add_video video_id }

    it { expect(@playlist.playlist_items.count).to be > 0 }
    it { expect(@playlist.playlist_items.first).to be_a Yt::PlaylistItem }
  end

  describe '#add_video' do
    context 'given an existing video' do
      let(:video_id) { 'MESycYJytkU' }
      it { expect(@playlist.add_video video_id).to be_a Yt::PlaylistItem }
      it { expect{@playlist.add_video video_id}.to change{@playlist.playlist_items.count}.by(1) }
    end

    context 'given an unknown video' do
      let(:video_id) { 'not-a-video' }
      it { expect(@playlist.add_video video_id).to be_nil }
      it { expect{@playlist.add_video video_id}.not_to change{@playlist.playlist_items.count} }
    end

    context 'given a video of a terminated account' do
      let(:video_id) { 'kDCpdKeTe5g' }
      it { expect(@playlist.add_video video_id).to be_nil }
      it { expect{@playlist.add_video video_id}.not_to change{@playlist.playlist_items.count} }
    end
  end

  describe '#add_video!' do
    context 'given an existing video' do
      let(:video_id) { 'MESycYJytkU' }
      it { expect(@playlist.add_video video_id).to be_a Yt::PlaylistItem }
    end

    context 'given an unknown video' do
      let(:video_id) { 'not-a-video' }
      it { expect{@playlist.add_video! video_id}.to fail.with 'videoNotFound' }
    end

    context 'given a video of a terminated account' do
      let(:video_id) { 'kDCpdKeTe5g' }
      it { expect{@playlist.add_video! video_id}.to fail.with 'forbidden' }
    end
  end

  describe '#add_videos' do
    context 'given one existing and one unknown video' do
      let(:video_ids) { ['MESycYJytkU', 'not-a-video'] }
      it { expect(@playlist.add_videos video_ids).to have(2).items }
      it { expect{@playlist.add_videos video_ids}.to change{@playlist.playlist_items.count}.by(1) }
    end
  end

  describe '#add_videos!' do
    context 'given one existing and one unknown video' do
      let(:video_ids) { ['MESycYJytkU', 'not-a-video'] }
      it { expect{@playlist.add_videos! video_ids}.to fail.with 'videoNotFound'}
    end
  end

  describe '#delete_playlist_items' do
    let(:video_id) { 'MESycYJytkU' }
    before { @playlist.add_video video_id }

    it { expect(@playlist.delete_playlist_items.uniq).to eq [true] }
    it { expect{@playlist.delete_playlist_items}.to change{@playlist.playlist_items.count} }
  end
end