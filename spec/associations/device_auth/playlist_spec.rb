require 'spec_helper'
require 'yt/models/playlist'

describe Yt::Playlist, :device_app do
  let(:playlist) { Yt::Playlist.new id: id, auth: $account }

  context 'given an existing playlist' do
    let(:id) { 'PLSWYkYzOrPMRCK6j0UgryI8E0NHhoVdRc' }

    it { expect(playlist.snippet).to be_a Yt::Snippet }
    it { expect(playlist.status).to be_a Yt::Status }
  end

  context 'given an unknown playlist' do
    let(:id) { 'not-a-playlist-id' }

    it { expect{playlist.snippet}.to raise_error Yt::Errors::NoItems }
    it { expect{playlist.status}.to raise_error Yt::Errors::NoItems }
  end
end