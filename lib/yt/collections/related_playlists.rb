require 'yt/collections/playlists'

module Yt
  module Collections
    class RelatedPlaylists < Playlists

    private

      # Retrieving related playlists requires to hit the /channels endpoint.
      def list_resources
        'channels'
      end

      # The related playlists are included in the content details of a channel.
      def playlists_params
        {part: 'contentDetails', id: @parent.id}
      end

      # The object to create is "Yt::Models::Playlist", not "RelatedPlaylist"
      def resource_class
        Yt::Models::Playlist
      end

      # The related playlists are nested inside the "relatedPlaylists" key.
      def extract_items(list)
        if (items = super).any?
          items.first['contentDetails'].fetch 'relatedPlaylists', {}
        end
      end

      # Since there are at most 5 related playlists, they can be eager-loaded.
      def eager_load_items_from(items)
        conditions = {id: items.values.join(','), part: 'snippet,status'}
        Collections::Playlists.new(auth: @auth).where conditions
      end

      # Related playlists are eager-loaded, there’s no need to load them again.
      def new_item(playlist)
        playlist
      end
    end
  end
end
