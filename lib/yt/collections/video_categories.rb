require 'yt/collections/base'

module Yt
  module Collections
    # Provides methods to interact with a collection of YouTube video categories.
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
          params[:params] = video_category_params
        end
      end

      def video_category_params
        {}.tap do |params|
          params[:part] = 'snippet'
          params[:id] = @parent.category_id if @parent
          apply_where_params! params
        end
      end

    end
  end
end
