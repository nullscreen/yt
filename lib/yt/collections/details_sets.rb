require 'yt/collections/base'
require 'yt/models/details_set'

module Yt
  module Collections
    class DetailsSets < Base

      def initialize(options = {})
        @video = options[:video]
        @auth = options[:auth]
      end

      def self.by_video(video)
        new video: video, auth: video.auth
      end

    private

      def new_item(data)
        Yt::DetailsSet.new data: data['contentDetails']
      end

      def list_params
        super.tap do |params|
          params[:params] = {maxResults: 50, part: 'contentDetails', id: @video.id}
          params[:scope] = 'https://www.googleapis.com/auth/youtube.readonly'
          params[:path] = '/youtube/v3/videos'
        end
      end
    end
  end
end