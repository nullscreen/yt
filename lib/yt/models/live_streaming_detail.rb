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
      def actual_start_time
        @actual_start_time ||= if @data['actualStartTime']
          Time.parse @data['actualStartTime']
        end
      end

      # @return [Time] if the broadcast is over, the time that the broadcast
      #   actually ended.
      # @return [nil] if the broadcast is not over.
      def actual_end_time
        @actual_end_time ||= if @data['actualEndTime']
          Time.parse @data['actualEndTime']
        end
      end

      # @return [Time] the time that the broadcast is scheduled to begin.
      def scheduled_start_time
        @scheduled_start_time ||= if @data['scheduledStartTime']
          Time.parse @data['scheduledStartTime']
        end
      end

      # @return [Time] if the broadcast is scheduled to end, the time that the
      #   broadcast is scheduled to end.
      # @return [nil] if the broadcast is scheduled to continue indefinitely.
      def scheduled_end_time
        @scheduled_end_time ||= if @data['scheduledEndTime']
          Time.parse @data['scheduledEndTime']
        end
      end

      # @return [Integer] if the broadcast has current viewers and the
      #   broadcast owner has not hidden the viewcount for the video, the
      #   number of viewers currently watching the broadcast.
      # @return [nil] if the broadcast has ended or the broadcast owner has
      #   hidden the viewcount for the video.
      def concurrent_viewers
        @concurrent_viewers ||= if @data['concurrentViewers']
          @data['concurrentViewers'].to_i
        end
      end
    end
  end
end