module Yt
  class DetailsSet < Base

    def initialize(options = {})
      @data = options[:data]
    end

    # Return the duration of the YouTube video.
    #
    # @return [Integer] Duration in seconds of the YouTube video
    def duration
      @duration = to_seconds @data.fetch('duration', 0)
    end
    # also available: dimension, definition, caption, licensed_content?

  private

    # The length of the video. The tag value is an ISO 8601 duration in the format PT#M#S,
    # in which the letters PT indicate that the value specifies a period of time, and
    # the letters M and S refer to length in minutes and seconds, respectively. The #
    # characters preceding the M and S letters are both integers that specify the number
    # of minutes (or seconds) of the video. For example, a value of PT15M51S indicates
    # that the video is 15 minutes and 51 seconds long.
    def to_seconds(iso8601_duration)
      match = iso8601_duration.match %r{^PT(?:|(?<min>\d*?)M)(?:|(?<sec>\d*?)S)$}
      minutes = (match[:min] || '0').to_i
      seconds = (match[:sec]).to_i
      minutes * 60 + seconds
    end
  end
end