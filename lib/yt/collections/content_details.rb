require 'yt/collections/base'
require 'yt/models/content_detail'

module Yt
  module Collections
    class ContentDetails < Base

    private

      # @return [Yt::Models::ContentDetail] a new content detail initialized
      #   with one of the items returned by asking YouTube for a list of them.
      def new_item(data)
        Yt::ContentDetail.new data: data['contentDetails']
      end

      # @return [Hash] the parameters to submit to YouTube to get the
      #   content detail of a resource, for instance a video.
      # @see https://developers.google.com/youtube/v3/docs/videos#resource
      def list_params
        super.tap do |params|
          params[:params] = {maxResults: 50, part: 'contentDetails', id: @parent.id}
          params[:path] = '/youtube/v3/videos'
        end
      end
    end
  end
end