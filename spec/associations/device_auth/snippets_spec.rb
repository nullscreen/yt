require 'spec_helper'
require 'yt/associations/snippets'
require 'yt/models/channel'
require 'yt/models/video'

describe Yt::Associations::Snippets, :device_app do
  describe '#snippet' do
    context 'given an existing video resource' do
      let(:video) { Yt::Video.new id: 'MESycYJytkU', auth: $account }
      it { expect(video.snippet).to be_a Yt::Snippet }
    end

    context 'given an unknown video resource' do
      let(:video) { Yt::Video.new id: 'not-a-video-id', auth: $account }
      it { expect{video.snippet}.to raise_error Yt::Errors::NoItems }
    end

    context 'given an existing channel resource' do
      let(:channel) { Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow', auth: $account }
      it { expect(channel.snippet).to be_a Yt::Snippet }
    end

    context 'given an unknown channel resource' do
      let(:channel) { Yt::Channel.new id: 'not-a-channel-id', auth: $account }
      it { expect{channel.snippet}.to raise_error Yt::Errors::NoItems }
    end
  end
end