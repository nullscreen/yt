require 'yt/collections/base'
require 'yt/models/annotation'

module Yt
  module Collections
    class Annotations < Base

    private

      def new_item(data)
        Yt::Annotation.new data: data
      end

      def list_params
        super.tap do |params|
          params[:format] = :xml
          params[:host] = 'www.youtube.com'
          params[:path] = '/annotations_invideo'
          params[:params] = {video_id: @parent.id}
          params[:expected_response] = Net::HTTPOK
        end
      end

      def next_page
        request = Yt::Request.new list_params
        response = request.run
        @page_token = nil

        document = response.body.fetch('document', {})['annotations'] || {}
        Array.wrap document.fetch 'annotation', []
      end
    end
  end
end