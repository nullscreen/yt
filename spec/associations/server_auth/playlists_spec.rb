require 'spec_helper'
require 'yt/models/channel'
require 'yt/models/playlist'

describe Yt::Associations::Playlists, scenario: :server_app do
  describe '#playlists' do
    subject(:playlists) { channel.playlists }

    context 'given an existing channel with playlists' do
      let(:channel) { Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow' }
      it { expect(playlists.first).to be_a Yt::Playlist }
    end
  end

  # Creating and deleting playlist cannot be tested with a server app because
  # only authenticated clients can perform those actions
end