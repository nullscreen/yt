require 'yt/collections/playlists'

module Yt
  module Associations
    # Provides the `has_many :playlists` method to YouTube resources, which
    # allows to invoke playlist-related methods, such as .create_playlist.
    # YouTube resources with playlist are: channels.
    module Playlists
      def playlists
        @playlists ||= Collections::Playlists.by_channel self
      end

      def create_playlist(params = {})
        playlists.insert params
      end

      def delete_playlists(attrs = {})
        playlists.delete_all attrs
      end
    end
  end
end