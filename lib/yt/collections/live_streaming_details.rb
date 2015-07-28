require 'yt/collections/base'
require 'yt/models/live_streaming_detail'

module Yt
  module Collections
    # @private
    class LiveStreamingDetails < Base

    private

      def attributes_for_new_item(data)
        {data: data['liveStreamingDetails']}
      end

      # @return [Hash] the parameters to submit to YouTube to get the
      #   live streaming detail of a resource, for instance a video.
      # @see https://developers.google.com/youtube/v3/docs/videos#resource
      def list_params
        super.tap do |params|
          params[:params] = live_streaming_details_params
          params[:path] = '/youtube/v3/videos'
        end
      end

      def live_streaming_details_params
        {max_results: 50, part: 'liveStreamingDetails', id: @parent.id}
      end
    end
  end
end