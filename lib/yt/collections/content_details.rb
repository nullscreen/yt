require 'yt/collections/base'
require 'yt/models/content_detail'

module Yt
  module Collections
    # @private
    class ContentDetails < Base

    private

      def attributes_for_new_item(data)
        {data: data['contentDetails']}
      end

      # @return [Hash] the parameters to submit to YouTube to get the
      #   content detail of a resource, for instance a video.
      # @see https://developers.google.com/youtube/v3/docs/videos#resource
      def list_params
        endpoint = @parent.kind.pluralize.camelize :lower
        super.tap do |params|
          params[:params] = content_details_params
          params[:path] = "/youtube/v3/#{endpoint}"
        end
      end

      def content_details_params
        {max_results: 50, part: 'contentDetails', id: @parent.id}
      end
    end
  end
end
