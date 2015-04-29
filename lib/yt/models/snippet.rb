require 'yt/models/description'

module Yt
  module Models
    # Contains basic information about the resource. The details of the snippet
    # are different for the different types of resources.
    #
    # Resources with a
    # snippet are: channels, playlists, playlist items and videos.
    # @see https://developers.google.com/youtube/v3/docs/channels#resource
    # @see https://developers.google.com/youtube/v3/docs/videos#resource
    # @see https://developers.google.com/youtube/v3/docs/playlists#resource
    # @see https://developers.google.com/youtube/v3/docs/playlistItems#resource
    class Snippet < Base
      attr_reader :data

      def initialize(options = {})
        @data = options[:data]
        @auth = options[:auth]
      end

      # @return [String] if the resource is a channel, the channel’s title.
      # @return [String] if the resource is a playlist, the playlist’s title.
      # @return [String] if the resource is a playlist item, the item’s title.
      has_attribute :title, default: ''

      # @return [Yt::Models::Description] if the resource is a channel, the
      #   channel’s description. Has a maximum of 1000 characters.
      # @return [Yt::Models::Description] if the resource is a playlist, the
      #   playlist’s description.
      # @return [Yt::Models::Description] if the resource is a playlist item,
      #   the item’s description.
      has_attribute :description, default: '' do |description_text|
        Description.new description_text
      end

      # @return [Time] if the resource is a channel, the date and time that the
      #  channel was created.
      # @return [Time] if the resource is a playlist, the date and time that
      #   the playlist was created.
      # @return [Time] if the resource is a playlist item, the date and time
      #   that the item was added to the playlist.
      has_attribute :published_at, type: Time

      # @param [Symbol, String] size The size of the thumbnail to retrieve.
      # @return [String] if the resource is a channel and +size+ is +default+,
      #   the URL of an 88x88px image.
      # @return [String] if the resource is a playlist or a playlist item and
      #   +size+ is +default+, the URL of an 120x90px image.
      # @return [String] if the resource is a channel and +size+ is +medium+,
      #   the URL of an 240x240px image.
      # @return [String] if the resource is a playlist or a playlist item and
      #   +size+ is +medium+, the URL of an 320x180px image.
      # @return [String] if the resource is a channel and +size+ is +high+,
      #   the URL of an 800x800px image.
      # @return [String] if the resource is a playlist or a playlist item and
      #   +size+ is +high+, the URL of an 480x360px image.
      # @return [nil] if the +size+ is not +default+, +medium+ or +high+.
      def thumbnail_url(size = :default)
        thumbnails.fetch(size.to_s, {})['url']
      end

      # @return [String] if the resource is a playlist, the ID that YouTube
      #   uses to uniquely identify the channel that the playlist belongs to.
      # @return [String] if the resource is a playlist item, the ID that YouTube
      #   uses to uniquely identify the channel that the playlist belongs to.
      # @return [nil] if the resource is a channel.
      has_attribute :channel_id

      # @return [String] if the resource is a playlist, the title of the
      #   channel that the playlist belongs to.
      # @return [String] if the resource is a playlist item, the title of the
      #   channel that the playlist item belongs to.
      # @return [nil] if the resource is a channel.
      has_attribute :channel_title

      # @return [Array<Yt::Models::Tag>] if the resource is a channel, an
      #   empty array.
      # @return [Array<Yt::Models::Tag>] if the resource is a playlist, the
      #   list of keyword tags associated with the playlist.
      # @return [Array<Yt::Models::Tag>] if the resource is a playlist item,
      #   an empty array.
      has_attribute :tags, default: []

      has_attribute :category_id

      BROADCAST_TYPES = %q(live none upcoming)

      has_attribute :live_broadcast_content

      # @return [String] if the resource is a playlist item, the ID that
      #   YouTube uses to uniquely identify the playlist that the item is in.
      # @return [nil] if the resource is a channel.
      # @return [nil] if the resource is a playlist.
      has_attribute :playlist_id

      # @return [Integer] if the resource is a playlist item, the order in
      #   which the item appears in a playlist. The value is zero-based, so the
      #   first item has a position of 0, the second item of 1, and so forth.
      # @return [nil] if the resource is a channel.
      # @return [nil] if the resource is a playlist.
      has_attribute :position, type: Integer

      # @return [String] if the resource is a playlist item, the ID of the
      #   video the playlist item represents in the playlist.
      # @return [nil] if the resource is a channel.
      # @return [nil] if the resource is a playlist.
      def video_id
        resource_id['videoId']
      end

      # @return [Yt::Models::Video] the video the playlist item represents in
      #   the playlist.
      # @return [nil] if the resource is a channel.
      # @return [nil] if the resource is a playlist.
      def video
        @video ||= Video.new id: video_id, auth: @auth if video_id
      end

      # Returns whether YouTube API includes all attributes in this snippet.
      # For instance, YouTube API only returns tags and categoryId on
      # Videos#list, not on Videos#search. And returns position on
      # PlaylistItems#list, not on PlaylistItems#insert.
      # This method is used to guarantee that, when a video was instantiated
      # by one of the methods above, an additional call to is made to retrieve
      # the full snippet in case an attribute is missing.
      # @see https://developers.google.com/youtube/v3/docs/videos
      # @return [Boolean] whether YouTube API includes the complete snippet.
      def complete?
        @complete ||= data.fetch :complete, true
      end

    private

      has_attribute :thumbnails, default: {}
      has_attribute :resource_id, default: {}
    end
  end
end