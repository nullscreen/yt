require 'spec_helper'
require 'yt/associations/videos'

describe Yt::Associations::Videos, :device_app do
  describe '#videos' do
    context 'given a channel with videos' do
      let(:channel) { Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow', auth: $account }
      it { expect(channel.videos.count).to be > 0 }
      it { expect(channel.videos.first).to be_a Yt::Video }
    end

    # NOTE: with an unknown channel id, YouTube behaves weirdly: if the
    # wrong channel ID starts with "UC" then it returns 0 results, otherwise
    # it ignores the channel filter and returns 100,000 results.
    context 'given an unknown channel starting with UC' do
      let(:channel) { Yt::Channel.new id: 'UC-not-a-channel', auth: $account }
      it { expect(channel.videos.count).to be 0 }
    end
  end
end