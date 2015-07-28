require 'yt/models/base'

module Yt
  module Models
    # @private
    # Encapsulates information about a live video broadcast.
    # The object will only be present in a video resource if the video is an
    # upcoming, live, or completed live broadcast.
    # @see https://developers.google.com/youtube/v3/docs/videos#resource
    class LiveStreamingDetail < Base

      def initialize(options = {})
        @data = options[:data] || {}
      end

      has_attribute :actual_start_time, type: Time
      has_attribute :actual_end_time, type: Time
      has_attribute :scheduled_start_time, type: Time
      has_attribute :scheduled_end_time, type: Time
      has_attribute :concurrent_viewers, type: Integer
    end
  end
end