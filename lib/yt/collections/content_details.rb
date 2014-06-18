require 'yt/collections/base'
require 'yt/models/content_detail'

module Yt
  module Collections
    class ContentDetails < Base

    private

      def new_item(data)
        Yt::ContentDetail.new data: data['contentDetails']
      end

      def list_params
        super.tap do |params|
          params[:params] = {maxResults: 50, part: 'contentDetails', id: @parent.id}
          params[:path] = '/youtube/v3/videos'
        end
      end
    end
  end
end