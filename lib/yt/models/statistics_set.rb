require 'yt/models/base'

module Yt
  module Models
    # Encapsulates statistics about the resource, such as the number of times
    # the resource has been viewed or liked.
    # @see https://developers.google.com/youtube/v3/docs/videos#resource
    class StatisticsSet < Base
      def initialize(options = {})
        @data = options[:data]
      end

      # @return [Integer] the number of times the resource has been viewed.
      def view_count
        @view_count ||= @data['viewCount'].to_i
      end

      # @return [Integer] the number of comments for the resource.
      def comment_count
        @comment_count ||= @data['commentCount'].to_i
      end

      # @return [Integer] the number of users who liked the resource.
      def like_count
        @like_count ||= @data['likeCount'].to_i
      end

      # @return [Integer] the number of users who disliked the resource.
      def dislike_count
        @dislike_count ||= @data['dislikeCount'].to_i
      end

      # @return [Integer] the number of users who currently have the resource
      #   marked as a favorite resource.
      def favorite_count
        @favorite_count ||= @data['favoriteCount'].to_i
      end

      # @return [Integer] the number of videos updated to the resource.
      def video_count
        @video_count ||= @data['videoCount'].to_i
      end

      # @return [Integer] the number of subscriber the resource has.
      def subscriber_count
        @subscriber_count ||= @data['subscriberCount'].to_i
      end

      # @return [Boolean] whether the number of subscribers is publicly visible.
      def subscriber_count_visible?
        @subscriber_count_visible ||= @data['hiddenSubscriberCount'] == false
      end
    end
  end
end