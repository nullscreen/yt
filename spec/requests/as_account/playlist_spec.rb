# encoding: UTF-8

require 'spec_helper'
require 'yt/models/playlist'

describe Yt::Playlist, :device_app do
  subject(:playlist) { Yt::Playlist.new id: id, auth: $account }

  context 'given an existing playlist' do
    let(:id) { 'PLSWYkYzOrPMRCK6j0UgryI8E0NHhoVdRc' }

    it 'returns valid metadata' do
      expect(playlist.title).to be_a String
      expect(playlist.description).to be_a String
      expect(playlist.thumbnail_url).to be_a String
      expect(playlist.published_at).to be_a Time
      expect(playlist.tags).to be_an Array
      expect(playlist.channel_id).to be_a String
      expect(playlist.channel_title).to be_a String
      expect(playlist.privacy_status).to be_in Yt::Status::PRIVACY_STATUSES
    end

    it { expect(playlist.playlist_items.first).to be_a Yt::PlaylistItem }
  end

  context 'given an unknown playlist' do
    let(:id) { 'not-a-playlist-id' }

    it { expect{playlist.snippet}.to raise_error Yt::Errors::NoItems }
    it { expect{playlist.status}.to raise_error Yt::Errors::NoItems }
  end

  context 'given someone else’s playlist' do
    let(:id) { 'PLSWYkYzOrPMRCK6j0UgryI8E0NHhoVdRc' }
    let(:video_id) { 'MESycYJytkU' }

    it { expect{playlist.delete}.to fail.with 'forbidden' }
    it { expect{playlist.update}.to fail.with 'forbidden' }
    it { expect{playlist.add_video! video_id}.to raise_error Yt::Errors::RequestError }
    it { expect{playlist.delete_playlist_items}.to raise_error Yt::Errors::RequestError }
  end

  context 'given one of my own playlists that I want to delete' do
    before(:all) { @my_playlist = $account.create_playlist title: "Yt Test Delete Playlist #{rand}" }
    let(:id) { @my_playlist.id }

    it { expect(playlist.delete).to be true }
  end

  context 'given one of my own playlists that I want to update' do
    before(:all) { @my_playlist = $account.create_playlist title: "Yt Test Update Playlist #{rand}" }
    after(:all) { @my_playlist.delete }
    let(:id) { @my_playlist.id }

    describe 'updates the attributes that I specify explicitly' do
      let(:attrs) { {title: "Yt Test Update Playlist #{rand} - new title"} }
      it { expect(playlist.update attrs).to eq true }
      it { expect{playlist.update attrs}.to change{playlist.title} }
    end

    describe 'does not update the other attributes' do
      let(:attrs) { {} }
      it { expect(playlist.update attrs).to eq true }
      it { expect{playlist.update attrs}.not_to change{playlist.title} }
      it { expect{playlist.update attrs}.not_to change{playlist.description} }
      it { expect{playlist.update attrs}.not_to change{playlist.tags} }
      it { expect{playlist.update attrs}.not_to change{playlist.privacy_status} }
    end

    context 'given an existing video' do
      let(:video_id) { 'MESycYJytkU' }

      describe 'can be added' do
        it { expect(playlist.add_video video_id).to be_a Yt::PlaylistItem }
        it { expect{playlist.add_video video_id}.to change{playlist.playlist_items.count}.by(1) }
        it { expect(playlist.add_video! video_id).to be_a Yt::PlaylistItem }
        it { expect{playlist.add_video! video_id}.to change{playlist.playlist_items.count}.by(1) }
      end

      describe 'can be removed' do
        before { playlist.add_video video_id }

        it { expect(playlist.delete_playlist_items.uniq).to eq [true] }
        it { expect{playlist.delete_playlist_items}.to change{playlist.playlist_items.count} }
      end
    end

    context 'given an unknown video' do
      let(:video_id) { 'not-a-video' }

      describe 'cannot be added' do
        it { expect(playlist.add_video video_id).to be_nil }
        it { expect{playlist.add_video video_id}.not_to change{playlist.playlist_items.count} }
        it { expect{playlist.add_video! video_id}.to fail.with 'videoNotFound' }
      end
    end

    context 'given a video of a terminated account' do
      let(:video_id) { 'kDCpdKeTe5g' }

      describe 'cannot be added' do
        it { expect(playlist.add_video video_id).to be_nil }
        it { expect{playlist.add_video video_id}.not_to change{playlist.playlist_items.count} }
        it { expect{playlist.add_video! video_id}.to fail.with 'forbidden' }
      end
    end

    context 'given one existing and one unknown video' do
      let(:video_ids) { ['MESycYJytkU', 'not-a-video'] }

      describe 'only one can be added' do
        it { expect(playlist.add_videos(video_ids).length).to eq 2 }
        it { expect{playlist.add_videos video_ids}.to change{playlist.playlist_items.count}.by(1) }
        it { expect{playlist.add_videos! video_ids}.to fail.with 'videoNotFound' }
      end
    end
  end
end