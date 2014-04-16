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