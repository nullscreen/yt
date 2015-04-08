require 'yt/models/base'

module Yt
  module Models
    # Encapsulates statistics about the resource, such as the number of times
    # the resource has been viewed or liked.
    # @see https://developers.google.com/youtube/v3/docs/videos#resource
    class StatisticsSet < Base
      attr_reader :data

      def initialize(options = {})
        @data = options[:data]
      end

      # @return [Integer] the number of times the resource has been viewed.
      has_attribute :view_count, type: Integer

      # @return [Integer] the number of comments for the resource.
      has_attribute :comment_count, type: Integer

      # @return [Integer] the number of users who liked the resource.
      has_attribute :like_count, type: Integer

      # @return [Integer] the number of users who disliked the resource.
      has_attribute :dislike_count, type: Integer

      # @return [Integer] the number of users who currently have the resource
      #   marked as a favorite resource.
      has_attribute :favorite_count, type: Integer

      # @return [Integer] the number of videos updated to the resource.
      has_attribute :video_count, type: Integer

      # @return [Integer] the number of subscriber the resource has.
      has_attribute :subscriber_count, type: Integer

      # @return [Boolean] whether the number of subscribers is publicly visible.
      has_attribute :subscriber_count_visible?, from: :hidden_subscriber_count do |hidden|
        hidden == false
      end
    end
  end
end