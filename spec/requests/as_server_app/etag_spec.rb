# frozen_string_literal: true

require 'spec_helper'
require 'yt/models/channel'
require 'yt/models/playlist'
require 'yt/models/video'

describe 'Etag support', server_app: true do
  context 'when making API requests' do
    it 'returns etag for public channel' do
      VCR.use_cassette('etag_public_channel') do
        channel = Yt::Channel.new(id: 'UCJkWoS4RsldA1coEIot5yDA') # MotherGooseClub
        expect(channel.etag).to be_present
      end
    end

    it 'returns etag for public playlist' do
      VCR.use_cassette('etag_public_playlist') do
        playlist = Yt::Playlist.new(id: 'PLgnDMw6xI5plOXaKs5zNDB3zRWYEa8Zi-') # Valid public playlist from existing tests
        expect(playlist.etag).to be_present
      end
    end

    it 'returns etag for public video' do
      VCR.use_cassette('etag_public_video') do
        video = Yt::Video.new(id: '9bZkp7q19f0') # PSY - GANGNAM STYLE
        expect(video.etag).to be_present
      end
    end
  end
end 