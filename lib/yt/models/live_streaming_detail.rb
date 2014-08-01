require 'yt/models/base'

module Yt
  module Models
    # Encapsulates information about the live content
    # @see https://developers.google.com/youtube/v3/docs/videos#resource
    class LiveStreamingDetail < Base

      def initialize(options = {})
        @data = options[:data]
      end

      # @return [Time] The time that the broadcast actually started
      def actual_start_time
        @actual_start_time ||= Time.zone.parse @data['actualStartTime'] if @data['actualStartTime']
      end

      # @return [Time] The time that the broadcast actually ended
      def actual_end_time
        @actual_end_time ||= Time.zone.parse @data['actualEndTime'] if @data['actualEndTime']
      end

      # @return [Time] The time that the broadcast is scheduled to begin
      def scheduled_start_time
        print @data['scheduledStartTime']
        @scheduled_start_time ||= Time.zone.parse @data['scheduledStartTime'] if @data['scheduledStartTime']
      end

      # @return [Time] The time that the broadcast is scheduled to end
      def scheduled_end_time
        @scheduled_end_time ||= Time.zone.parse @data['scheduledEndTime'] if @data['scheduledEndTime']
      end

      # @return [integer] The number of viewers currently watching the broadcast.
      def concurrent_viewers
        @concurrent_viewers ||= @data['concurrentViewers'].to_i
      end

    end
  end
end