require 'yt/models/resource'

module Yt
  module Models
    # Provides methods to interact with YouTube playlist items.
    # @see https://developers.google.com/youtube/v3/docs/playlistItems
    class PlaylistItem < Resource
      delegate :channel_id, :channel_title, :playlist_id, :video_id,
        :video, to: :snippet

      def delete(options = {})
        do_delete {@id = nil}
        !exists?
      end

      def exists?
        !@id.nil?
      end

      # Returns the position of the item in the playlist.
      # Since YouTube API does not return the position on PlaylistItem#create,
      # the memoized @snippet is erased if the video was instantiated like that,
      # so that the full snippet (with position) is loaded, rather than the
      # partial one.
      # @see https://developers.google.com/youtube/v3/docs/playlistItems
      # @return [Integer] the order in which the item appears in a playlist.
      def position
        unless snippet.position || snippet.complete? || @auth.nil?
          @snippet = nil
        end
        snippet.position
      end

    private

      def resource_id
        {kind: 'youtube#video', videoId: video_id}
      end

      # @see https://developers.google.com/youtube/v3/docs/playlistItems/update
      def update_parts
        keys = [:position, :playlist_id, :resource_id]
        snippet = {keys: keys, required: true}
        {snippet: snippet}
      end
    end
  end
end