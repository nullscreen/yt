require 'yt/models/base'

module Yt
  module Models
    # Encapsulates information about a video player.
    # @see https://developers.google.com/youtube/v3/docs/videos#player
    class Player < Base
      attr_reader :data

      def initialize(options = {})
        @data = options[:data]
      end

      # @return [String] the HTML code of an <iframe> tag that embeds a
      #   player that will play the video.
      has_attribute :embed_html
    end
  end
end