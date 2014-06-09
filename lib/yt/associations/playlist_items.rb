require 'yt/collections/playlist_items'

module Yt
  module Associations
    # Provides the `has_many :playlist_items` method to YouTube resources, which
    # allows to invoke playlist_item-related methods, such as .add_video.
    # YouTube resources with playlist items are: playlists.
    module PlaylistItems
      def playlist_items
        @playlist_items ||= Collections::PlaylistItems.of self
      end
    end
  end
end