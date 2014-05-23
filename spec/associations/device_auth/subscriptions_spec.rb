require 'spec_helper'
require 'yt/models/channel'

# NOTE: This test is slow because we *must* wait for some seconds between
# subscribing and unsubscribing to a channel, otherwise YouTube will show
# wrong (cached) data, such as a user is subscribed when he is not.
describe Yt::Associations::Subscriptions, :device_app do
  describe '#subscription' do
    context 'given an existing channel' do
      let(:channel) { Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow', auth: $account }

      context 'that I am not subscribed to' do
        before { channel.unsubscribe }
        it { expect(channel.subscribed?).to be_false }
        it { expect(channel.subscribe!).to be_true }
      end

      context 'that I am subscribed to' do
        before { channel.subscribe }
        it { expect(channel.subscribed?).to be_true }
        it { expect(channel.unsubscribe!).to be_true }
      end
    end
  end
end