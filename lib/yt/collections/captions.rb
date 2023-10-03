require 'yt/collections/base'

module Yt
  module Collections
    # Provides methods to interact with a collection of video captions.
    class Captions < Resources

      private

      def attributes_for_new_item(data)
        {id: data['id'], snippet: data['snippet'], auth: @auth}
      end

      def list_params
        super.tap do |params|
          params[:path] = "/youtube/v3/captions"
          params[:params] = captions_params
        end
      end

      def captions_params
        {}.tap do |params|
          params[:part] = 'snippet'
          params[:video_id] = @parent.id if @parent
          apply_where_params! params
        end
      end
    end
  end
end
