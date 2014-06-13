require 'yt/models/description'

module Yt
  module Models
    # Encapsulates information about the snippet of a resource, for
    # instance a channel.
    # @see https://developers.google.com/youtube/v3/docs/channels#resource
    class Snippet
      def initialize(options = {})
        @data = options[:data]
      end

      # @return [String] the resource’s title.
      def title
        @title ||= @data.fetch 'title', ''
      end

      # @return [Yt::Models::Description] the resource’s description.
      def description
        @description ||= Description.new @data.fetch('description', '')
      end

      # @return [Time or nil] the date and time that the resource was created.
      def published_at
        @published_at ||= Time.parse @data['publishedAt']
      end

      # Return the tags of a YouTube resource.
      #
      # @return [Array] An array of Yt::Tag object, one for each tag of the resource.
      #
      # @note YouTube API only includes tags in a resource’s snippet if the
      #       resource is a video belonging to the authenticated account.
      def tags
        @tags ||= @data.fetch 'tags', []
      end

      # @return [String] a thumbnail image associated with the resource.
      # @param [Symbol or String] size The size of the thumbnail to retrieve.
      #   Valid values are: default, medium, high.
      #   For a resource that refers to a video, default equals 120x90px,
      #   medium equals 320x180px, high equals 480x360px.
      #   For a resource that refers to a channel, default equals 88x88px,
      #   medium equals 240x240px, high equals 800x800px.
      def thumbnail_url(size = :default)
        @thumbnails ||= @data.fetch 'thumbnails', {}
        @thumbnails.fetch(size.to_s, {})['url']
      end
    end
  end
end