# encoding: UTF-8

require 'spec_helper'
require 'yt/models/channel'

describe Yt::Channel, :server_app do
  let(:channel) { Yt::Channel.new id: id }

  describe '.snippet of existing channel' do
    let(:id) { 'UCxO1tY8h1AhOz0T4ENwmpow' }
    it { expect(channel.snippet).to be_a Yt::Snippet }
  end

  describe '.snippet of unknown channel' do
    let(:id) { 'not-a-channel-id' }
    it { expect{channel.snippet}.to raise_error Yt::Errors::NoItems }
  end

  describe '.status of existing channel' do
    let(:id) { 'UCxO1tY8h1AhOz0T4ENwmpow' }
    it { expect(channel.status).to be_a Yt::Status }
  end

  describe '.status of unknown channel' do
    let(:id) { 'not-a-channel-id' }
    it { expect{channel.status}.to raise_error Yt::Errors::NoItems }
  end

  describe '.videos of existing channel' do
    let(:id) { 'UCxO1tY8h1AhOz0T4ENwmpow' }
    it { expect(channel.videos).to be_a Yt::Collections::Videos }
    it { expect(channel.videos.first).to be_a Yt::Video }
  end

  describe '.videos of unknown channel starting with UC' do
    let(:id) { 'UC-not-a-channel-id' }

    # NOTE: This test is just a reflection of YouTube irrational behavior of
    # returns 0 results if the name of an unknown channel starts with UC, but
    # returning 100,000 results otherwise (ignoring the channel filter).
    it { expect(channel.videos.count).to be 0 }
  end

  describe '.playlists of someone else’s channel' do
    let(:id) { 'UCxO1tY8h1AhOz0T4ENwmpow' }

    it { expect(channel.playlists).to be_a Yt::Collections::Playlists }
    it { expect(channel.playlists.first).to be_a Yt::Playlist }
  end
end