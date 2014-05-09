require 'spec_helper'
require 'yt/models/playlist'
require 'yt/models/playlist_item'

describe Yt::Associations::PlaylistItems, scenario: :server_app do
  describe '#playlist_items' do
    subject(:playlist_items) { playlist.playlist_items }

    context 'given an existing playlist with items' do
      let(:playlist) { Yt::Playlist.new id: 'PLSWYkYzOrPMRCK6j0UgryI8E0NHhoVdRc' }
      it { expect(playlist_items.first).to be_a Yt::PlaylistItem }
    end
  end

  # Creating and deleting playlist items cannot be tested with a server
  # app because only authenticated clients can perform those actions
end