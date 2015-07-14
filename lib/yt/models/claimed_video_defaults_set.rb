require 'yt/models/base'

module Yt
  module Models
    # This object identifies the advertising options used by default for the
    # content owner's newly claimed videos.
    # @see https://developers.google.com/youtube/partner/docs/v1/contentOwnerAdvertisingOptions
    class ClaimedVideoDefaultsSet < Base
      def initialize(options = {})
        @data = options[:data]
      end

      # Set this property to true to indicate that the
      # channel's claimedVideoOptions can override the content owner's claimedVideoOptions.
      # @return [Boolean]
      has_attribute :channel_override

      # @return [Array<String>] A list of ad formats that could be used as the
      # default settings for a newly claimed video. The first partner that claims the video sets its default advertising options to that video.
      has_attribute :new_video_defaults, default: []
    end
  end
end
