require 'yt/collections/base'
require 'yt/models/rating'

module Yt
  module Collections
    class Ratings < Base

      def initialize(options = {})
        @video = options[:video]
        @auth = options[:auth]
      end

      def self.by_video(video)
        new video: video, auth: video.auth
      end

    private

      def new_item(data)
        Yt::Rating.new rating: data['rating'], video_id: @video.id, auth: @auth
      end

      def list_params
        super.tap do |params|
          params[:path] = '/youtube/v3/videos/getRating'
          params[:params] = {id: @video.id}
          params[:scope] = 'https://www.googleapis.com/auth/youtube'
        end
      end
    end
  end
end