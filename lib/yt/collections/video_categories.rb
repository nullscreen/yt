require 'yt/collections/base'
require 'yt/models/video_category'

module Yt
  module Collections
    class VideoCategories < Base

    private

      def attributes_for_new_item(data)
        {}.tap do |attributes|
          attributes[:id] = data['id']
          attributes[:snippet] = data['snippet']
          attributes[:auth] = @auth
        end
      end

      # @return [Hash] the parameters to submit to YouTube to list video categories.
      # @see https://developers.google.com/youtube/v3/docs/videoCategories/list
      def list_params
        super.tap do |params|
          params[:params] = video_categories_params
        end
      end

      def video_categories_params
        {}.tap do |params|
          params[:part] = 'snippet'
          params[:id] = @parent.category_id if @parent
          apply_where_params! params
        end
      end
    end
  end
end
