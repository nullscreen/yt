require 'spec_helper'
require 'yt/models/channel'

describe Yt::Channel, :device_app do
  let(:channel) { Yt::Channel.new id: id, auth: $account }

  context 'given an existing channel' do
    let(:id) { 'UCxO1tY8h1AhOz0T4ENwmpow' }

    it { expect(channel.snippet).to be_a Yt::Snippet }
    it { expect(channel.status).to be_a Yt::Status }
  end

  context 'given an unknown channel' do
    let(:id) { 'not-a-channel-id' }

    it { expect{channel.snippet}.to raise_error Yt::Errors::NoItems }
    it { expect{channel.status}.to raise_error Yt::Errors::NoItems }
  end
end