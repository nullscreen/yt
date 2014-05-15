require 'yt/collections/base'
require 'yt/models/rating'

module Yt
  module Collections
    class Ratings < Base

    private

      def new_item(data)
        Yt::Rating.new rating: data['rating'], video_id: @parent.id, auth: @auth
      end

      def list_params
        super.tap do |params|
          params[:path] = '/youtube/v3/videos/getRating'
          params[:params] = {id: @parent.id}
        end
      end
    end
  end
end