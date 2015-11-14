require 'yt/models/base'

module Yt
  module Models
    # @private
    # Provides methods to interact with the recordingDetails of YouTube resources.
    # @see https://developers.google.com/youtube/v3/docs/videos#resource-representation
    class RecordingDetail < Base
      attr_reader :data

      def initialize(options = {})
        @data = options[:data] || {}
      end

      has_attribute :location_description
      has_attribute :location, default: {}
      has_attribute :recording_date, type: Time
    end
  end
end
