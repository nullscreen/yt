require 'yt/models/base'

module Yt
  module Models
    # Provides methods to interact with YouTube playlist items.
    # @see https://developers.google.com/youtube/v3/docs/playlistItems
    class PlaylistItem < Base
      # @return [String] the ID that uniquely identify a YouTube playlist item.
      attr_reader :id

      # @return [String] the order in which the item appears in the playlist.
      #   The value uses a zero-based index, so the first item has a position
      #   of 0, the second item has a position of 1, and so forth.
      attr_reader :position

      attr_reader :video

      def initialize(options = {})
        @id = options[:id]
        @auth = options[:auth]
        if options[:snippet]
          @position = options[:snippet]['position']
          @video = Video.new video_params_for options
        end
      end

      def delete
        do_delete {@id = nil}
        !exists?
      end

      def exists?
        !@id.nil?
      end

    private

      def delete_params
        super.tap do |params|
          params[:path] = '/youtube/v3/playlistItems'
          params[:params] = {id: @id}
        end
      end

      def video_params_for(options = {})
        {}.tap do |params|
          params[:id] = options[:snippet].fetch('resourceId', {})['videoId']
          params[:snippet] = options[:snippet].except 'resourceId'
          params[:auth] = options[:auth]
        end
      end
    end
  end
end