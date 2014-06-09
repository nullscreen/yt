# encoding: UTF-8

require 'spec_helper'
require 'yt/models/playlist'

describe Yt::Playlist, :server_app do
  let(:playlist) { Yt::Playlist.new id: id }

  describe '.snippet of existing playlist' do
    let(:id) { 'PLSWYkYzOrPMRCK6j0UgryI8E0NHhoVdRc' }
    it { expect(playlist.snippet).to be_a Yt::Snippet }
  end

  describe '.status of existing playlist' do
    let(:id) { 'PLSWYkYzOrPMRCK6j0UgryI8E0NHhoVdRc' }
    it { expect(playlist.status).to be_a Yt::Status }
  end

  describe '.snippet of unknown playlist' do
    let(:id) { 'not-a-playlist-id' }
    it { expect{playlist.snippet}.to raise_error Yt::Errors::NoItems }
  end

  describe '.status of unknown playlist' do
    let(:id) { 'not-a-playlist-id' }
    it { expect{playlist.status}.to raise_error Yt::Errors::NoItems }
  end

  describe '.playlist_items of someone else’s playlist' do
    let(:id) { 'PLSWYkYzOrPMRCK6j0UgryI8E0NHhoVdRc' }
    let(:video_id) { 'MESycYJytkU' }

    it { expect(playlist.playlist_items).to be_a Yt::Collections::PlaylistItems }
    it { expect(playlist.playlist_items.first).to be_a Yt::PlaylistItem }
  end
end
