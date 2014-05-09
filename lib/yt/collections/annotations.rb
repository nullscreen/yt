require 'yt/collections/base'
require 'yt/models/annotation'

module Yt
  module Collections
    class Annotations < Base

      def initialize(options = {})
        @video = options[:video]
        @auth = options[:auth]
      end

      def self.by_video(video)
        new video: video, auth: video.auth
      end

    private

      def new_item(data)
        Yt::Annotation.new data: data
      end

      def list_params
        super.tap do |params|
          params[:format] = :xml
          params[:host] = 'www.youtube.com'
          params[:path] = '/annotations_invideo'
          params[:params] = {video_id: @video.id}
        end
      end

      def next_page
        request = Request.new list_params
        response = request.run
        raise unless response.is_a? Net::HTTPOK
        @page_token = nil

        document = response.body.fetch('document', {})['annotations'] || {}
        Array.wrap document.fetch 'annotation', []
      end
    end
  end
end