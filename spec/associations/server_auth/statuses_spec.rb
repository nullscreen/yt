require 'spec_helper'
require 'yt/associations/statuses'
require 'yt/models/channel'
require 'yt/models/video'
require 'yt/models/playlist'

describe Yt::Associations::Statuses, :server_app do
  describe '#status' do
    context 'given an existing video resource' do
      let(:video) { Yt::Video.new id: 'MESycYJytkU' }
      it { expect(video.status).to be_a Yt::Status }
    end

    context 'given an unknown video resource' do
      let(:video) { Yt::Video.new id: 'not-a-video-id' }
      it { expect{video.status}.to raise_error Yt::Errors::NoItems }
    end

    context 'given an existing channel resource' do
      let(:channel) { Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow' }
      it { expect(channel.status).to be_a Yt::Status }
    end

    context 'given an unknown channel resource' do
      let(:channel) { Yt::Channel.new id: 'not-a-channel-id' }
      it { expect{channel.status}.to raise_error Yt::Errors::NoItems }
    end

    context 'given an existing playlist resource' do
      let(:playlist) { Yt::Playlist.new id: 'PLSWYkYzOrPMRCK6j0UgryI8E0NHhoVdRc' }
      it { expect(playlist.status).to be_a Yt::Status }
    end

    context 'given an unknown playlist resource' do
      let(:playlist) { Yt::Playlist.new id: 'not-a-playlist-id' }
      it { expect{playlist.status}.to raise_error Yt::Errors::NoItems }
    end
  end
end