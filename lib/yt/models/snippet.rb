require 'yt/models/description'

module Yt
  module Models
    # Contains basic information about the resource. The details of the snippet
    # are different for the different types of resources. Resources with a
    # snippet are: channels, videos, playlists, playlist items.
    # @see https://developers.google.com/youtube/v3/docs/channels#resource
    # @see https://developers.google.com/youtube/v3/docs/videos#resource
    class Snippet
      def initialize(options = {})
        @data = options[:data]
        @auth = options[:auth]
      end

      # @return [String] the resource’s title.
      #   For channels: the channel’s title.
      #   For videos: the video’s title. Has a maximum of 100 characters and
      #     may contain all valid UTF-8 characters except < and >.
      #   For playlists: the playlist’s title.
      #   For playlist items: the item’s title.
      def title
        @title ||= @data.fetch 'title', ''
      end

      # @return [Yt::Models::Description] the resource’s description.
      #   For channels: the channel’s description. Has a maximum of 1000
      #     characters.
      #   For videos: the video’s description. Has a maximum of 5000 bytes and
      #     may contain all valid UTF-8 characters except < and >.
      #   For playlists: the playlist’s description.
      #   For playlist items: the item’s description.
      def description
        @description ||= Description.new @data.fetch('description', '')
      end

      # @return [Time] the date and time that the resource was published.
      #   For channels: the date and time that the channel was created.
      #   For videos: the date and time that the video was published.
      #   For playlists: the date and time that the playlist was created.
      #   For playlist items: the date and time that the item was added to the
      #     playlist.
      def published_at
        @published_at ||= Time.parse @data['publishedAt']
      end

      # @param [Symbol or String] size The size of the thumbnail to retrieve.
      # @return [String or nil] a thumbnail image associated with the resource.
      #   For channels: sizes correspond to 88x88px (default), 240x240px
      #     (medium), and 800x800px (high).
      #   For videos, playlists, playlist items: sizes correspond to 120x90px
      #     (default), 320x180px (medium), and 480x360px (high).
      def thumbnail_url(size = :default)
        @thumbnails ||= @data.fetch 'thumbnails', {}
        @thumbnails.fetch(size.to_s, {})['url']
      end

      # @return [String or nil] the ID of the related channel.
      #   For videos: the ID that YouTube uses to uniquely identify the
      #     channel that the video was uploaded to.
      #   For playlists: the ID that YouTube uses to uniquely identify the
      #     channel that published the playlist.
      #   For playlist items: the ID that YouTube uses to uniquely identify
      #     the user that added the item to the playlist.
      def channel_id
        @channel_id ||= @data['channelId']
      end

      # @return [String or nil] the title of the related channel.
      #   For videos: the title of the channel the video belongs to.
      #   For playlists: the title of the channel the playlist belongs to.
      #   For playlist items: the title of the channel the playlist item
      #     belongs to.
      def channel_title
        @channel_title ||= @data['channelTitle']
      end

      # @return [Array<Yt::Models::Tag>] A list of associated keyword tags.
      #   For videos: tags are only visible to the video’s uploader.
      #   For playlists: keyword tags associated with the playlist.
      def tags
        @tags ||= @data.fetch 'tags', []
      end

      # @return [String or nil] the YouTube video category associated with the
      #   video (for videos only).
      # @see https://developers.google.com/youtube/v3/docs/videoCategories/list
      def category_id
        @category_id ||= @data['categoryId']
      end

      # @return [String or nil] whether the resource is an upcoming/active live
      #   broadcast. Valid values are: live, none, upcoming (for videos only).
      def live_broadcast_content
        @live_broadcast_content ||= @data['liveBroadcastContent']
      end

      # @return [String or nil] the ID that YouTube uses to uniquely identify
      #   the playlist that the item is in (for playlist items only).
      def playlist_id
        @playlist_id ||= @data['playlistId']
      end

      # @return [Integer or nil] the order in which the item appears in a
      #   playlist. The value is zero-based, so the first item has a position
      #   of 0, the second item of 1, and so forth (for playlist items only).
      def position
        @position ||= @data['position'].to_i
      end

      # @return [String or nil] the ID of the video the playlist item
      #   represents in the playlist (only for playlist items).
      def video_id
        @video_id ||= @data.fetch('resourceId', {})['videoId']
      end

      # @return [Yt::Models::Video or nil] the video the playlist item
      #   represents in the playlist (only for playlist items).
      def video
        @video ||= Video.new id: video_id, auth: @auth if video_id
      end
    end
  end
end