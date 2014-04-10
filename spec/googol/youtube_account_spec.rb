require 'spec_helper'
require 'googol/youtube_account'

describe Googol::YoutubeAccount do
  it 'provides a URL for users to authenticate' do
    expect(Googol::YoutubeAccount.oauth_url).to be
  end

  context 'given a valid account authentication' do
    before :all do
      auth_params = {refresh_token: ENV['GOOGOL_TEST_YOUTUBE_REFRESH_TOKEN']}
      @account = Googol::YoutubeAccount.new auth_params
    end

    it 'provides access to the ID' do
      expect(@account.id).to be
    end

    it 'provides access to the title' do
      expect(@account.title).to be
    end

    it 'provides access to the description' do
      expect(@account.description).to be
    end

    it 'provides access to the thumbnail_url' do
      expect(@account.thumbnail_url).to be
    end

    it 'allows to like the video "Tongue" by R.E.M. for that account' do
      video = {video_id: 'Kd5M17e7Wek'}
      expect(@account.like! video).to be
    end

    it 'allows to subscribe to the Fullscreen channel for that account' do
      channel = {channel_id: 'UCxO1tY8h1AhOz0T4ENwmpow'}
      expect{@account.subscribe_to! channel}.not_to raise_error
    end

    it 'does not allow to subscribe to a video (unrecognized activity)' do
      video = {video_id: 'Kd5M17e7Wek'}
      expect{@account.subscribe_to! video}.to raise_error Googol::RequestError
    end

    it 'allows to add the video "Tongue" to a new playlist' do
      filters = {title: "Googol #{rand}", description: "Test", max: 1}
      playlist_id = @account.find_or_create_playlist_by filters do |playlist|
        expect(playlist).to be
      end
      params = {video_id: 'Kd5M17e7Wek', playlist_id: playlist_id}
      expect(@account.add_to! params).to be
    end

    it 'allows to add the video "Tongue" to an existing playlist' do
      playlist_id = @account.find_or_create_playlist_by title: //, max: 1
      params = {video_id: 'Kd5M17e7Wek', playlist_id: playlist_id}
      expect(@account.add_to! params).to be
    end
  end

  context 'given a missing account authentication' do
    let(:account) { Googol::YoutubeAccount.new }

    it {expect{account.id}.to raise_error Googol::RequestError}
  end

  context 'given an invalid authentication code' do
    let(:account) { Googol::YoutubeAccount.new code: 'invalid' }

    it {expect{account.id}.to raise_error Googol::RequestError}
  end

  context 'given an invalid refresh token' do
    let(:account) { Googol::YoutubeAccount.new refresh_token: 'invalid' }

    it {expect{account.id}.to raise_error Googol::RequestError}
  end

  context 'given an auth token and not a refresh token' do
    let(:account) { Googol::YoutubeAccount.new access_token: 'qwerty' }

    it {expect(account.credentials[:access_token]).to eq 'qwerty'}
  end
end