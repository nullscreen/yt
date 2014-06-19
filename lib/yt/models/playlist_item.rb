require 'yt/models/resource'

module Yt
  module Models
    # Provides methods to interact with YouTube playlist items.
    # @see https://developers.google.com/youtube/v3/docs/playlistItems
    class PlaylistItem < Resource
      delegate :channel_id, :channel_title, :playlist_id, :position, :video_id,
        :video, to: :snippet

      def delete(options = {})
        do_delete {@id = nil}
        !exists?
      end

      def exists?
        !@id.nil?
      end

    private

      # @return [Hash] the parameters to submit to YouTube to delete a playlist item.
      # @see https://developers.google.com/youtube/v3/docs/playlistItems/delete
      def delete_params
        super.tap do |params|
          params[:path] = '/youtube/v3/playlistItems'
          params[:params] = {id: @id}
        end
      end
    end
  end
end