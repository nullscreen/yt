require 'yt/collections/base'
require 'yt/models/file_detail'

module Yt
  module Collections
    # @private
    class ProcessingDetails < Base

    private

      def attributes_for_new_item(data)
        {data: data['processingDetails']}
      end

      # @return [Hash] the parameters to submit to YouTube to get the
      #   file detail of a video.
      # @see https://developers.google.com/youtube/v3/docs/videos#fileDetails
      def list_params
        super.tap do |params|
          params[:params] = processing_details_params
          params[:path] = '/youtube/v3/videos'
        end
      end

      def processing_details_params
        {max_results: 50, part: 'processingDetails', id: @parent.id}
      end
    end
  end
end
