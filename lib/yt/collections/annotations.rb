require 'yt/collections/base'
require 'yt/models/annotation'

module Yt
  module Collections
    # Provides methods to interact with a collection of YouTube annotations.
    #
    # Resources with annotations are: {Yt::Models::Video videos}.
    # @note Since there is no (authenticable) API endpoint to retrieve
    #   annotations, only annotations of public videos can be retrieved.
    class Annotations < Base

    private

      # @return [Hash] the parameters to submit to YouTube to list annotations.
      # @note YouTube does not provide an API endpoint to get annotations for
      #   a video, so we use an "old-style" URL that YouTube still maintains.
      def list_params
        super.tap do |params|
          params[:response_format] = :xml
          params[:host] = 'www.youtube.com'
          params[:path] = '/annotations_invideo'
          params[:params] = {video_id: @parent.id}
          params[:camelize_params] = false
          params[:expected_response] = Net::HTTPOK
        end
      end

      # @private
      # @note Annotations overwrites +next_page+ since the list of annotations
      #   is not paginated API-style, but in its own custom way.
      def next_page
        request = Yt::Request.new(list_params).tap do |request|
          print "#{request.as_curl}\n" if Yt.configuration.developing?
        end
        response = request.run
        @page_token = nil

        document = response.body.fetch('document', {})['annotations'] || {}
        Array.wrap document.fetch 'annotation', []
      rescue Yt::Error => error
        expected?(error) ? [] : raise(error)
      end

      # @private
      # @note Annotations overwrites +total_results+ since `items_key` is
      #   not `items` for annotations.
      # @todo Remove this function by extracting the keys used by annotations
      #   in a method and reusing them both in `next_page` and `total_results`.
      def total_results
        count
      end

      # Since there is no API endpoint, retrieving annotations of unknown
      # videos or of private videos (to which YouTube responds with 403)
      # should not raise an error, but simply not return any annotation.
      def expected?(error)
        error.is_a? Yt::Errors::Forbidden
      end
    end
  end
end