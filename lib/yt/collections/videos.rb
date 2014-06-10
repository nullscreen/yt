require 'yt/collections/base'
require 'yt/models/video'

module Yt
  module Collections
    class Videos < Base

      def initialize(options)
        @q = options[:q]
        super
      end

    private

      def new_item(data)
        Yt::Video.new id: data['id']['videoId'], snippet: data['snippet'], auth: @auth
      end

      def list_params
        super.tap do |params|
          params[:params] = {type: :video, maxResults: 50, part: 'snippet'}

          if @parent.auth == @auth
            params[:params].merge! forMine: true, q: @q
          else
            params[:params].merge! channelId: @parent.id
          end

          params[:path] = '/youtube/v3/search'
        end
      end
    end
  end
end