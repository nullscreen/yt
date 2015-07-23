require 'yt/models/resource'

module Yt
  module Models
    # Provides methods to interact with YouTube playlist items.
    # @see https://developers.google.com/youtube/v3/docs/playlistItems
    class PlaylistItem < Resource

    ### SNIPPET ###

      # @!attribute [r] title
      #   @return [String] the item’s title.
      delegate :title, to: :snippet

      # @!attribute [r] description
      #   @return [String] the item’s description.
      delegate :description, to: :snippet

      # @!method thumbnail_url(size = :default)
      #   Returns the URL of the item’s thumbnail.
      #   @param [Symbol, String] size The size of the item’s thumbnail.
      #   @return [String] if +size+ is +default+, the URL of a 120x90px image.
      #   @return [String] if +size+ is +medium+, the URL of a 320x180px image.
      #   @return [String] if +size+ is +high+, the URL of a 480x360px image.
      #   @return [nil] if the +size+ is not +default+, +medium+ or +high+.
      delegate :thumbnail_url, to: :snippet

      # @!attribute [r] published_at
      #   @return [Time] the time that the item was added to the playlist.
      delegate :published_at, to: :snippet

      # @!attribute [r] channel_id
      #   @return [String] the ID of the channel that the item belongs to.
      delegate :channel_id, to: :snippet

      # @!attribute [r] channel_title
      #   @return [String] the title of the channel that the item belongs to.
      delegate :channel_title, to: :snippet

      # @!attribute [r] playlist_id
      #   @return [String] the ID of the playlist that the item is in.
      delegate :playlist_id, to: :snippet

      # @return [String] the ID of the video referred by the item.
      def video_id
        snippet.resource_id['videoId']
      end

      # @return [Integer] the order in which the item appears in a playlist.
      #   The value is zero-based, so the first item has a position of 0.
      def position
        ensure_complete_snippet :position
      end

    ### ACTIONS (UPLOAD, UPDATE, DELETE) ###

      # Deletes the playlist item.
      # @return [Boolean] whether the playlist item does not exist anymore.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} is not an
      #   authenticated Yt::Account with permissions to delete the item.
      def delete(options = {})
        do_delete {@id = nil}
        !exists?
      end

      # Updates the attributes of a playlist item.
      # @return [Boolean] whether the item was successfully updated.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} is not an
      #   authenticated Yt::Account with permissions to update the item.
      # @param [Hash] attributes the attributes to update.
      # @option attributes [Integer] the order in which the item should appear
      #   in a playlist. The value is zero-based, so the first position of 0.
      def update(attributes = {})
        super
      end

    ### ASSOCIATIONS ###

      # @return [Yt::Models::Video] the video referred by the item.
      def video
        @video ||= Video.new id: video_id, auth: @auth if video_id
      end

    ### PRIVATE API ###

      # @private
      def exists?
        !@id.nil?
      end

      # @private
      # Override Resource's new to set video if the response includes it
      def initialize(options = {})
        super options
        @video = options[:video] if options[:video]
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