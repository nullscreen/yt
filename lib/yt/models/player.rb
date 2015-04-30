require 'yt/models/base'

module Yt
  module Models
    # @private
    # Encapsulates information about a video player.
    # @see https://developers.google.com/youtube/v3/docs/videos#player
    class Player < Base
      attr_reader :data

      def initialize(options = {})
        @data = options[:data]
      end

      has_attribute :embed_html
    end
  end
end