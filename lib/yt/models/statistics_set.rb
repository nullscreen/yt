require 'yt/models/base'

module Yt
  module Models
    # @private
    # Encapsulates statistics about the resource, such as the number of times
    # the resource has been viewed or liked.
    # @see https://developers.google.com/youtube/v3/docs/videos#resource
    class StatisticsSet < Base
      attr_reader :data

      def initialize(options = {})
        @data = options[:data]
      end

      has_attribute :view_count, type: Integer
      has_attribute :comment_count, type: Integer
      has_attribute :like_count, type: Integer
      has_attribute :dislike_count, type: Integer
      has_attribute :favorite_count, type: Integer
      has_attribute :video_count, type: Integer
      has_attribute :subscriber_count, type: Integer
      has_attribute :hidden_subscriber_count
    end
  end
end