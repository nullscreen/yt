# encoding: UTF-8

require 'spec_helper'
require 'yt/models/video'
require 'yt/models/playlist'
require 'yt/models/channel'

describe 'Etag Integration Tests', :device_app, :vcr do
  describe 'Video etag' do
    context 'given a real YouTube video' do
      let(:video) { Yt::Video.new id: '9bZkp7q19f0', auth: test_account }

      it 'returns a valid etag' do
        expect(video.etag).to be_a String
        expect(video.etag).not_to be_empty
        expect(video.etag).to match(/^[A-Za-z0-9_-]+$/)
      end

      it 'returns the same etag on subsequent calls' do
        first_etag = video.etag
        second_etag = video.etag
        expect(first_etag).to eq second_etag
      end
    end

    context 'given a video from my account' do
      let(:video) { test_account.videos.first }

      it 'returns a valid etag' do
        expect(video.etag).to be_a String
        expect(video.etag).not_to be_empty
        expect(video.etag).to match(/^[A-Za-z0-9_-]+$/)
      end
    end
  end

  describe 'Playlist etag' do
    context 'given a real YouTube playlist' do
      let(:playlist) { Yt::Playlist.new id: 'PLSWYkYzOr', auth: test_account }

      it 'returns a valid etag' do
        expect(playlist.etag).to be_a String
        expect(playlist.etag).not_to be_empty
        expect(playlist.etag).to match(/^[A-Za-z0-9_-]+$/)
      end

      it 'returns the same etag on subsequent calls' do
        first_etag = playlist.etag
        second_etag = playlist.etag
        expect(first_etag).to eq second_etag
      end
    end

    context 'given a playlist from my account' do
      let(:playlist) { test_account.playlists.first }

      it 'returns a valid etag' do
        expect(playlist.etag).to be_a String
        expect(playlist.etag).not_to be_empty
        expect(playlist.etag).to match(/^[A-Za-z0-9_-]+$/)
      end
    end
  end

  describe 'Channel etag' do
    context 'given a real YouTube channel' do
      let(:channel) { Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow', auth: test_account }

      it 'returns a valid etag' do
        expect(channel.etag).to be_a String
        expect(channel.etag).not_to be_empty
        expect(channel.etag).to match(/^[A-Za-z0-9_-]+$/)
      end

      it 'returns the same etag on subsequent calls' do
        first_etag = channel.etag
        second_etag = channel.etag
        expect(first_etag).to eq second_etag
      end
    end

    context 'given my own channel' do
      let(:channel) { test_account.channel }

      it 'returns a valid etag' do
        expect(channel.etag).to be_a String
        expect(channel.etag).not_to be_empty
        expect(channel.etag).to match(/^[A-Za-z0-9_-]+$/)
      end
    end
  end

  describe 'Collection etags' do
    context 'given videos collection' do
      let(:videos) { test_account.videos }

      it 'returns a valid etag' do
        expect(videos.etag).to be_a String
        expect(videos.etag).not_to be_empty
        expect(videos.etag).to match(/^[A-Za-z0-9_-]+$/)
      end

      it 'returns the same etag on subsequent calls' do
        first_etag = videos.etag
        second_etag = videos.etag
        expect(first_etag).to eq second_etag
      end
    end

    context 'given playlists collection' do
      let(:playlists) { test_account.playlists }

      it 'returns a valid etag' do
        expect(playlists.etag).to be_a String
        expect(playlists.etag).not_to be_empty
        expect(playlists.etag).to match(/^[A-Za-z0-9_-]+$/)
      end
    end

    context 'given subscribed channels collection' do
      let(:subscribed_channels) { test_account.subscribed_channels }

      it 'returns a valid etag' do
        expect(subscribed_channels.etag).to be_a String
        expect(subscribed_channels.etag).not_to be_empty
        expect(subscribed_channels.etag).to match(/^[A-Za-z0-9_-]+$/)
      end
    end
  end
end 