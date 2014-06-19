require 'spec_helper'
require 'yt/models/channel'

describe Yt::Channel, :server_app do
  subject(:channel) { Yt::Channel.new id: id }

  context 'given an existing channel' do
    let(:id) { 'UCxO1tY8h1AhOz0T4ENwmpow' }

    it 'returns valid snippet data' do
      expect(channel.snippet).to be_a Yt::Snippet
      expect(channel.title).to be_a String
      expect(channel.description).to be_a Yt::Description
      expect(channel.thumbnail_url).to be_a String
      expect(channel.published_at).to be_a Time
    end

    it { expect(channel.status).to be_a Yt::Status }
    it { expect(channel.statistics_set).to be_a Yt::StatisticsSet }
    it { expect(channel.videos).to be_a Yt::Collections::Videos }
    it { expect(channel.videos.first).to be_a Yt::Video }
    it { expect(channel.playlists).to be_a Yt::Collections::Playlists }
    it { expect(channel.playlists.first).to be_a Yt::Playlist }
  end

  context 'given an unknown channel' do
    let(:id) { 'not-a-channel-id' }

    it { expect{channel.snippet}.to raise_error Yt::Errors::NoItems }
    it { expect{channel.status}.to raise_error Yt::Errors::NoItems }
    it { expect{channel.statistics_set}.to raise_error Yt::Errors::NoItems }

    describe 'starting with UC' do
      let(:id) { 'UC-not-a-channel-id' }

      # NOTE: This test is just a reflection of YouTube irrational behavior of
      # returns 0 results if the name of an unknown channel starts with UC, but
      # returning 100,000 results otherwise (ignoring the channel filter).
      it { expect(channel.videos.count).to be 0 }
    end
  end
end