require 'yt/collections/base'
require 'yt/models/annotation'

module Yt
  module Collections
    # Provides methods to interact with a collection of YouTube annotations.
    # Resources with annotations are: {Yt::Models::Video videos}.
    class Annotations < Base

    private

      # @return [Yt::Models::Annotation] a new annotation initialized with one
      #   of the items returned by asking YouTube for a list of annotations.
      def new_item(data)
        Yt::Annotation.new data: data
      end

      # @return [Hash] the parameters to submit to YouTube to list annotations.
      # @note YouTube does not provide an API endpoint to get annotations for
      #   a video, so we use an "old-style" URL that YouTube still maintains.
      def list_params
        super.tap do |params|
          params[:format] = :xml
          params[:host] = 'www.youtube.com'
          params[:path] = '/annotations_invideo'
          params[:params] = {video_id: @parent.id}
          params[:expected_response] = Net::HTTPOK
        end
      end

      # @private
      # @note Annotations overwrites +next_page+ since the list of annotations
      #   is not paginated API-style, but in its own custom way.
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