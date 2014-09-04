require 'yt/models/base'

module Yt
  module Models
    # Encapsulates information about a live video broadcast.
    # The object will only be present in a video resource if the video is an
    # upcoming, live, or completed live broadcast.
    # @see https://developers.google.com/youtube/v3/docs/videos#resource
    class LiveStreamingDetail < Base

      def initialize(options = {})
        @data = options[:data] || {}
      end

      # @return [Time] if the broadcast has begun, the time that the broadcast
      #   actually started.
      # @return [nil] if the broadcast has not begun.
      has_attribute :actual_start_time, type: Time

      # @return [Time] if the broadcast is over, the time that the broadcast
      #   actually ended.
      # @return [nil] if the broadcast is not over.
      has_attribute :actual_end_time, type: Time

      # @return [Time] the time that the broadcast is scheduled to begin.
      has_attribute :scheduled_start_time, type: Time

      # @return [Time] if the broadcast is scheduled to end, the time that the
      #   broadcast is scheduled to end.
      # @return [nil] if the broadcast is scheduled to continue indefinitely.
      has_attribute :scheduled_end_time, type: Time

      # @return [Integer] if the broadcast has current viewers and the
      #   broadcast owner has not hidden the viewcount for the video, the
      #   number of viewers currently watching the broadcast.
      # @return [nil] if the broadcast has ended or the broadcast owner has
      #   hidden the viewcount for the video.
      has_attribute :concurrent_viewers, type: Integer
    end
  end
end