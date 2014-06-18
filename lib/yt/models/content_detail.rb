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
        @duration ||= to_seconds @data.fetch('duration', 0)
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

      # The duration of the resource as reported by YouTube. The value is an
      # ISO 8601 duration in the format PT#M#S, in which the letters PT
      # indicate that the value specifies a period of time, and the letters M
      # and S refer to length in minutes and seconds, respectively. The #
      # characters preceding the M and S letters are both integers that specify
      # the number of minutes (or seconds) of the video. For example, a value
      # of PT15M51S indicates that the video is 15 minutes and 51 seconds long.
      def to_seconds(iso8601_duration)
        match = iso8601_duration.match %r{^PT(?:|(?<hours>\d*?)H)(?:|(?<min>\d*?)M)(?:|(?<sec>\d*?)S)$}
        hours = (match[:hours] || '0').to_i
        minutes = (match[:min] || '0').to_i
        seconds = (match[:sec]).to_i
        (hours * 60 + minutes) * 60 + seconds
      end
    end
  end
end