require 'yt/models/base'

module Yt
  module Models
    # Encapsulates information about the video content, including the length
    # of the video and an indication of whether captions are available.
    # @see https://developers.google.com/youtube/v3/docs/videos#resource
    class ContentDetail < Base

      def initialize(options = {})
        @data = options[:data]
      end

      # @return [Integer] the duration of the video (in seconds).
      def duration
        @duration ||= youtube_duration_to_seconds @data.fetch('duration', 0)
      end

      # @return [Boolean] whether the video is available in 3D.
      def stereoscopic?
        @stereoscopic ||= @data['dimension'] == '3d'
      end

      # @return [Boolean] whether the video is available in high definition.
      def hd?
        @hd ||= @data['definition'] == 'hd'
      end

      # @return [Boolean] whether captions are available for the video.
      def captioned?
        @hd ||= @data['caption'] == 'true'
      end

      # @return [Boolean] whether the video represents licensed content, which
      #   means that the content has been claimed by a YouTube content partner.
      def licensed?
        @licensed ||= @data.fetch 'licensedContent', false
      end

    private

      # https://developers.google.com/youtube/v3/docs/videos says, of the duration field:
      # The tag value is an ISO 8601 duration in the format PT#M#S, in which the letters PT indicate that
      # the value specifies a period of time, and the letters M and S refer to length in minutes and seconds, respectively.
      # The # characters preceding the M and S letters are both integers that specify the number of minutes (or seconds)
      # of the video.
      #
      # The above is wrong on a few points. First, and most practically relevant, the duration is not always in the
      # form PT#M#S. It scales to omit zeros, so video tPEE9ZwTmy0 has duration PT2S and video 2XwmldWC_Ls has
      # duration P1W2DT6H21M32S (800492 seconds) and video FvHiLLkPhQE has duration P1D (it's exactly 24 hours)
      #
      # As for the other problems, PT does not stand for Period of Time. An ISO 8601 duration does not represent
      # a specific number of seconds, it represents a calendar calculation, so that P1M can be a different number
      # of days depending on the base date it is added to (or subtracted from). Furthermore, ISO 8601 does not
      # allow mixing Weeks with other time units. "In both basic and extended format the complete representation of the
      # expression for duration shall be [PnnW] or [PnnYnnMnnDTnnHnnMnnS]."
      #
      # So were going to ignore all that and just do what YouTube (probably) intends, which is to treat days as always
      # being exactly 86400 seconds long (despite the 2 or 3 days a year that are not) and hope they keep adding Weeks
      # rather than at some point adding Months or Years which who knows how long they intend them to be.
      #
      def youtube_duration_to_seconds(yt_duration)
        duration = /^P
                  (\d+W)? # Weeks
                  (\d+D)? # Days
                  (T
                    (\d+H)? # Hours
                    (\d+M)? # Minutes
                    (\d+(?:\.\d+)?S)? # Seconds
                  )? # Time
                $/x.match(yt_duration)
        return nil unless duration
        seconds = 0
        seconds += (duration[1] || '0').to_i * 7 * 86400 # weeks
        seconds += (duration[2] || '0').to_i * 86400     # days
        seconds += (duration[4] || '0').to_i * 3600      # hours
        seconds += (duration[5] || '0').to_i * 60        # minutes
        seconds += (duration[6] || '0').to_i             # seconds

        seconds
      end
    end
  end
end