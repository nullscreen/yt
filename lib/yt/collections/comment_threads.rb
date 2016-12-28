require 'yt/collections/base'
require 'yt/models/video'
require 'yt/models/channel'

module Yt
  module Collections
    # @private
    class CommentThreads < Base

    private

      def attributes_for_new_item(data)
        {}.tap do |attributes|
          attributes[:id] = data['id']
          attributes[:snippet] = data['snippet']
          attributes[:auth] = @auth
        end
      end

      # @return [Hash] the parameters to submit to YouTube to get the resource.
      # @see https://developers.google.com/youtube/v3/docs/commentThreads#resource
      def list_params
        super.tap do |params|
          params[:path] = "/youtube/v3/commentThreads"
          params[:params] = comments_params
        end
      end

      def comments_params
        apply_where_params!({max_results: 100, part: 'snippet'}).tap do |params|
          case @parent
          when Yt::Video
            params[:videoId] = @parent.id
          when Yt::Channel
            params[:channelId] = @parent.id
          end
        end
      end
    end
  end
end
