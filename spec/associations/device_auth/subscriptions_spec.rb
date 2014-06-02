require 'spec_helper'
require 'yt/models/channel'

describe Yt::Associations::Subscriptions, :device_app do
  describe '#subscription' do
    # NOTE: These tests are slow because we *must* wait some seconds between
    # subscribing and unsubscribing to a channel, otherwise YouTube will show
    # wrong (cached) data, such as a user is subscribed when he is not.
    context 'given an existing channel' do
      let(:channel) { Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow', auth: $account }

      context 'that I am not subscribed to' do
        before { channel.unsubscribe }
        it { expect(channel.subscribed?).to be false }
        it { expect(channel.subscribe!).to be_truthy }
      end

      context 'that I am subscribed to' do
        before { channel.subscribe }
        it { expect(channel.subscribed?).to be true }
        it { expect(channel.unsubscribe!).to be_truthy }
      end
    end

    # NOTE: This test is just a reflection of YouTube irrational behavior of
    # raising a 500 error when you try to subscribe to your own channel, rather
    # than a more logical 4xx error. Hopefully this will get fixed and this
    # code (and test) removed.
    context 'given my own channel' do
      let(:channel) { Yt::Channel.new id: $account.channel.id, auth: $account }

      it { expect{channel.subscribe}.to raise_error Yt::Errors::ServerError }
    end
  end
end