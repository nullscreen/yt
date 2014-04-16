require 'spec_helper'
require 'googol/youtube_account'

describe Googol::YoutubeAccount do
  context 'given a valid account authentication' do
    before :all do
      auth_params = {refresh_token: ENV['GOOGOL_TEST_YOUTUBE_REFRESH_TOKEN']}
      @account = Googol::YoutubeAccount.new auth_params
      @channel = {channel_id: 'UCxO1tY8h1AhOz0T4ENwmpow'}
    end

    context 'given there is no subscription to the Fullscreen channel' do
      before { @account.unsubscribe_from @channel }
      it 'allows to subscribe to the Fullscreen channel' do
        expect(@account.subscribe_to! @channel).to be
      end

      it 'allows to "try" to unsubscribe from the Fullscreen channel' do
        expect(@account.unsubscribe_from @channel).to be
      end

      it 'does not allow to unsubscribe from the Fullscreen channel' do
        expect{@account.unsubscribe_from! @channel}.to raise_error Googol::RequestError
      end
    end

    context 'given there is a subscription to the Fullscreen channel' do
      before { @account.subscribe_to @channel }
      it 'allows to unsubscribe from the Fullscreen channel' do
        expect(@account.unsubscribe_from! @channel.merge(retries: 2)).to be
      end

      it 'does not allow to subscribe to the Fullscreen channel' do
        expect{@account.subscribe_to! @channel}.to raise_error Googol::RequestError
      end
    end

    context 'given there is more than one "page" of subscriptions' do
      before do
        @account.subscribe_to @channel
        @account.subscribe_to channel_id: 'UC1qEati6S1jyfXiYC8tmAaw'
      end

      it 'does not allow to unsubscribe from an unknown channel' do
        channel = {channel_id: 'invalid-id', max: 1, retries: 1}
        expect{@account.unsubscribe_from! channel}.to raise_error Googol::RequestError
      end
    end

    it 'does not allow to subscribe to a video (unrecognized activity)' do
      video = {video_id: 'Kd5M17e7Wek'}
      expect{@account.subscribe_to video}.to raise_error Googol::RequestError
    end

    it 'does not allow to unsubscribe from a video (unrecognized activity)' do
      video = {video_id: 'Kd5M17e7Wek'}
      expect{@account.unsubscribe_from video}.to raise_error Googol::RequestError
    end
  end
end