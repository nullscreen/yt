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
      params = [:like, :video, 'Kd5M17e7Wek']
      expect(@account.perform! *params).to be
    end

    it 'allows to subscribe to the R.E.M. channel for that account' do
      params = [:subscribe_to, :channel, 'UC7eaRqtonpyiYw0Pns0Au_g']
      expect{@account.perform! *params}.to be_or_be_already_subscribed
    end

    it 'raises an error for unrecognized activities' do
      params = [:kiss, :video, 'Kd5M17e7Wek']
      expect{@account.perform! *params}.to raise_error Googol::RequestError
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
end