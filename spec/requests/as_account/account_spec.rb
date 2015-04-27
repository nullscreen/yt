# encoding: UTF-8
require 'spec_helper'
require 'yt/models/account'

describe Yt::Account, :device_app do
  describe 'can create playlists' do
    let(:params) { {title: 'Test Yt playlist', privacy_status: 'unlisted'} }
    before { @playlist = $account.create_playlist params }
    it { expect(@playlist).to be_a Yt::Playlist }
    after { @playlist.delete }
  end

  describe '.channel' do
    it { expect($account.channel).to be_a Yt::Channel }
  end

  describe '.user_info' do
    it { expect($account.user_info).to be_a Yt::UserInfo }
  end

  describe '.videos' do
    let(:video) { $account.videos.where(order: 'viewCount').first }

    specify 'returns the videos uploaded by the account with their tags and category ID' do
      expect(video).to be_a Yt::Video
      expect(video.tags).not_to be_empty
      expect(video.category_id).not_to be_nil
    end

    describe '.where(q: query_string)' do
      let(:count) { $account.videos.where(q: query).count }

      context 'given a query string that matches any video owned by the account' do
        let(:query) { ENV['YT_TEST_MATCHING_QUERY_STRING'] }
        it { expect(count).to be > 0 }
      end

      context 'given a query string that does not match any video owned by the account' do
        let(:query) { '--not-a-matching-query-string--' }
        it { expect(count).to be_zero }
      end
    end

    describe 'ignores filters by ID (all the videos uploaded by the account are returned)' do
      let(:other_video) { $account.videos.where(order: 'viewCount', id: 'invalid').first }
      it { expect(other_video.id).to eq video.id }
    end

    describe 'ignores filters by chart (all the videos uploaded by the account are returned)' do
      let(:other_video) { $account.videos.where(order: 'viewCount', chart: 'invalid').first }
      it { expect(other_video.id).to eq video.id }
    end

    describe '.includes(:snippet)' do
      let(:video) { $account.videos.first }

      specify 'eager-loads the *full* snippet of each video' do
        expect(video.instance_variable_defined? :@snippet).to be true
        expect(video.channel_title).to be
        expect(video.snippet).to be_complete
      end
    end

    describe '.includes(:statistics, :status)' do
      let(:video) { $account.videos.includes(:statistics, :status).first }

      specify 'eager-loads the statistics and status of each video' do
        expect(video.instance_variable_defined? :@statistics_set).to be true
        expect(video.instance_variable_defined? :@status).to be true
      end
    end

    describe '.includes(:content_details)' do
      let(:video) { $account.videos.includes(:content_details).first }

      specify 'eager-loads the statistics of each video' do
        expect(video.instance_variable_defined? :@content_detail).to be true
      end
    end
  end

  describe '.upload_video' do
    let(:video_params) { {title: 'Test Yt upload', privacy_status: 'private', category_id: 17} }
    let(:video) { $account.upload_video path_or_url, video_params }
    after { video.delete }

    context 'given the path to a local video file' do
      let(:path_or_url) { File.expand_path '../video.mp4', __FILE__ }

      it { expect(video).to be_a Yt::Video }
    end

    context 'given the URL of a remote video file' do
      let(:path_or_url) { 'https://bit.ly/yt_test' }

      it { expect(video).to be_a Yt::Video }
    end
  end

  describe '.subscribers' do
    let(:subscriber) { $account.subscribers.first }

    specify 'returns the channels who are subscribed to me' do
      expect(subscriber).to be_a Yt::Channel
    end
  end
end