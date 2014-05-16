require 'yt/collections/base'
require 'yt/models/video'

module Yt
  module Collections
    class Videos < Base

    private

      def new_item(data)
        Yt::Video.new id: data['id']['videoId'], snippet: data['snippet'], auth: @auth
      end

      def list_params
        super.tap do |params|
          params[:params] = {channelId: @parent.id, type: :video, maxResults: 50, part: 'snippet'}
          params[:path] = '/youtube/v3/search'
        end
      end
    end
  end
end