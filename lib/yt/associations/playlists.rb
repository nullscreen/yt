require 'yt/collections/playlists'

module Yt
  module Associations
    # Provides the `has_many :playlists` method to YouTube resources, which
    # allows to invoke playlist-related methods, such as .create_playlist.
    # YouTube resources with playlist are: channels.
    module Playlists
      def playlists
        @playlists ||= Collections::Playlists.of self
      end
    end
  end
end