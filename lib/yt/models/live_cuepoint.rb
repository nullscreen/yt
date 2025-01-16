require 'yt/models/base'

module Yt
  module Models
    # Provides methods to interact with YouTube Content ID live cuepoints.
    # @see https://developers.google.com/youtube/v3/live/docs/liveCuepoints
    class LiveCuepoint < Base
      def initialize(options = {})
        @data = options[:data]
        @id = options[:id]
        @auth = options[:auth]
      end

      # @return [String] the ID that YouTube assigns and uses to uniquely
      #   identify the live_cuepoint.
      has_attribute :id

      # @return [String] the ID that uniquely identifies the broadcast that the
      #   live_cuepoint is associated with.
      has_attribute :broadcast_id
    end
  end
end
