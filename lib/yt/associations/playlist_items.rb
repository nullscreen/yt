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

      def add_video(video_id)
        playlist_items.insert({id: video_id, kind: :video}, ignore_errors: true)
      end

      def add_video!(video_id)
        playlist_items.insert id: video_id, kind: :video
      end

      def add_videos(video_ids = [])
        video_ids.map{|video_id| add_video video_id}
      end

      def add_videos!(video_ids = [])
        video_ids.map{|video_id| add_video! video_id}
      end

      def delete_playlist_items(attrs = {})
        playlist_items.delete_all attrs
      end
    end
  end
end