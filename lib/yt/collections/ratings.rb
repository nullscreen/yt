require 'yt/collections/resources'
require 'yt/models/rating'

module Yt
  module Collections
    class Ratings < Resources

    private

      def new_item(data)
        Yt::Rating.new rating: data['rating'], video_id: @parent.id, auth: @auth
      end

      def list_params
        super.tap do |params|
          params[:path] = '/youtube/v3/videos/getRating'
          params[:params] = {id: @parent.id}
          params[:scope] = 'https://www.googleapis.com/auth/youtube'
        end
      end
    end
  end
end