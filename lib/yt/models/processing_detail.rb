require 'yt/models/base'

module Yt
  module Models
    # @private
    # Encapsulates basic information about processing the uploaded video file,
    # including the processing status.
    # @see https://developers.google.com/youtube/v3/docs/videos#processingDetails
    class ProcessingDetail < Base
      attr_reader :data

      def initialize(options = {})
        @data = options[:data] || {}
      end

      # @return [String] the video's processing status. Possible values are:
      #   +'processing'+, +'succeeded'+, +'failed'+, +'terminated'+.
      has_attribute :processing_status
    end
  end
end
