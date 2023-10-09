# encoding: UTF-8

require 'spec_helper'
require 'yt/models/playlist'

describe Yt::Playlist, :device_app, :vcr do
  subject(:playlist) { Yt::Playlist.new id: id, auth: test_account }

  context 'given an existing playlist' do
    let(:id) { 'PLpjK416fmKwQlQ0KvTWFmXZZa3d4IO2ro' } # from YouTube Creators

    it 'returns valid metadata' do
      expect(playlist.title).to be_a String
      expect(playlist.description).to be_a String
      expect(playlist.thumbnail_url).to be_a String
      expect(playlist.published_at).to be_a Time
      expect(playlist.channel_id).to be_a String
      expect(playlist.channel_title).to be_a String
      expect(playlist.privacy_status).to be_a String
      expect(playlist.item_count).to be_an Integer
    end

    describe '.playlist_items' do
      let(:item) { playlist.playlist_items.first }

      specify 'returns the playlist item with the complete snippet' do
        expect(item).to be_a Yt::PlaylistItem
        expect(item.snippet).to be_complete
        expect(item.position).not_to be_nil
      end

      specify 'does not eager-load the attributes of the item’s video' do
        expect(item.video.instance_variable_defined? :@snippet).to be false
        expect(item.video.instance_variable_defined? :@status).to be false
        expect(item.video.instance_variable_defined? :@statistics_set).to be false
      end
    end

    describe '.playlist_items.includes(:video)' do
      let(:item) { playlist.playlist_items.includes(:video).first }

      specify 'eager-loads the snippet, status and statistics of each video' do
        expect(item.video.instance_variable_defined? :@snippet).to be true
        expect(item.video.instance_variable_defined? :@status).to be true
        expect(item.video.instance_variable_defined? :@statistics_set).to be true
      end
    end
  end

  context 'given an unknown playlist' do
    let(:id) { 'not-a-playlist-id' }

    it { expect{playlist.snippet}.to raise_error Yt::Errors::NoItems }
    it { expect{playlist.status}.to raise_error Yt::Errors::NoItems }
  end

  context 'given someone else’s playlist' do
    let(:id) { 'PLpjK416fmKwQlQ0KvTWFmXZZa3d4IO2ro' } # from YouTube Creators
    let(:video_id) { '9bZkp7q19f0' }

    it { expect{playlist.delete}.to fail.with 'playlistForbidden' }
    it { expect{playlist.update}.to fail.with 'playlistForbidden' }
    it { expect{playlist.add_video! video_id}.to raise_error Yt::Errors::RequestError }
    it { expect{playlist.delete_playlist_items}.to raise_error Yt::Errors::RequestError }
  end

  context 'given one of my own playlists that I want to delete' do
    let(:id) { 'PLwjDRP5ZX_MFsevR8diQ2lv3HbMo5xbKc' }

    it { expect(playlist.delete).to be true }
  end

  context 'given one of my own playlists that I want to update' do
    let(:id) { 'PLwjDRP5ZX_MFsevR8diQ2lv3HbMo5xbKc' }
    let!(:old_title) { playlist.title }
    let!(:old_privacy_status) { playlist.privacy_status }
    let(:update) { playlist.update attrs }

    context 'given I update the title' do
      # NOTE: The use of UTF-8 characters is to test that we can pass up to
      # 50 characters, independently of their representation
      let(:attrs) { {title: "Yt Example Update Playlist - ®•♡❥❦❧☙"} }

      specify 'only updates the title' do
        expect(update).to be true
        expect(playlist.title).not_to eq old_title
        expect(playlist.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the description' do
      let!(:old_description) { playlist.description }
      let(:attrs) { {description: "Yt Example Description - ®•♡❥❦❧☙"} }

      specify 'only updates the description' do
        expect(update).to be true
        expect(playlist.description).not_to eq old_description
        expect(playlist.title).to eq old_title
        expect(playlist.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update title or description using angle brackets' do
      let(:attrs) { {title: "Yt Test < >", description: '< >'} }

      specify 'updates them replacing angle brackets with similar unicode characters accepted by YouTube' do
        expect(update).to be true
        expect(playlist.title).to eq 'Yt Test ‹ ›'
        expect(playlist.description).to eq '‹ ›'
      end
    end

    context 'given I update the privacy status' do
      let!(:new_privacy_status) { old_privacy_status == 'private' ? 'unlisted' : 'private' }

      context 'passing the parameter in underscore syntax' do
        let(:attrs) { {privacy_status: new_privacy_status} }

        specify 'only updates the privacy status' do
          expect(update).to be true
          expect(playlist.privacy_status).not_to eq old_privacy_status
          expect(playlist.title).to eq old_title
        end
      end

      context 'passing the parameter in camel-case syntax' do
        let(:attrs) { {privacyStatus: new_privacy_status} }

        specify 'only updates the privacy status' do
          expect(update).to be true
          expect(playlist.privacy_status).not_to eq old_privacy_status
          expect(playlist.title).to eq old_title
        end
      end
    end

    context 'given an existing video' do
      let(:video_id) { '9bZkp7q19f0' } # Gangnam Style

      describe 'can be added' do
        it { expect(playlist.add_video video_id).to be_a Yt::PlaylistItem }
        it { expect{playlist.add_video video_id}.to change{ playlist.playlist_items.count}.by(1) }
        it { expect(playlist.add_video! video_id).to be_a Yt::PlaylistItem }
        it { expect{playlist.add_video! video_id}.to change{playlist.playlist_items.count}.by(1) }
        it { expect(playlist.add_video(video_id, position: 0).position).to be 0 }
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

    context 'given one existing and one unknown video' do
      let(:video_ids) { ['9bZkp7q19f0', 'not-a-video'] }

      describe 'only one can be added' do
        it { expect(playlist.add_videos(video_ids).length).to eq 2 }
        it { expect{playlist.add_videos video_ids}.to change{playlist.playlist_items.count}.by(1) }
        it { expect{playlist.add_videos! video_ids}.to fail.with 'videoNotFound' }
      end
    end
  end

  context 'given one of my own playlists that I want to get reports for' do
    let(:id) { test_account.channel.playlists.first.id }

    before do
      allow(Date).to receive(:today).and_return(Date.new(2020, 2, 5))
    end

    it 'returns valid reports for playlist-related metrics' do
      expect{playlist.views}.not_to raise_error
      expect{playlist.playlist_starts}.not_to raise_error
      expect{playlist.average_time_in_playlist}.not_to raise_error
      expect{playlist.views_per_playlist_start}.not_to raise_error
    end
  end
end
