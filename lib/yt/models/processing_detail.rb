require 'yt/models/base'

module Yt
  module Models
    # @private
    # Encapsulates basic information about YouTube's progress in processing the
    # uploaded video file.
    # @see https://developers.google.com/youtube/v3/docs/videos#processingDetails
    class ProcessingDetail < Base
      attr_reader :data

      def initialize(options = {})
        @data = options[:data] || {}
      end

      has_attribute :processing_status

    end
  end
end
