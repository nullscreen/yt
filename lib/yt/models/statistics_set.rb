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

      has_attribute :comment_count, type: Integer
      has_attribute :like_count, type: Integer
      has_attribute :dislike_count, type: Integer
      has_attribute :favorite_count, type: Integer
      has_attribute :video_count, type: Integer
      has_attribute :subscriber_count, type: Integer
      has_attribute :hidden_subscriber_count

      # @return [Boolean] whether the number of subscribers is publicly visible.
      has_attribute :subscriber_count_visible?, from: :hidden_subscriber_count do |hidden|
        hidden == false
      end
    end
  end
end