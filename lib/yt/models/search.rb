require 'yt/models/base'

module Yt
  module Models
    # A video search.
    # @see https://developers.google.com/youtube/v3/docs/search/list
    class Search < Base
      attr_reader :auth

      def initialize(query, options = {})
        @query = query

        @auth = options[:auth]
        @order = options[:order] || 'relevance'
        @safe_search = options[:safe_search] || 'moderate'
      end

      # @!attribute [r] videos
      #   @return [Yt::Collections::Videos] the videos returned by the search
      has_many :videos

      # @private
      # Tells `has_many :videos` what params to use in the /list API call.
      def videos_params
        {
          q: @query,
          order: @order,
          safe_search: @safe_search
        }
      end
    end
  end
end
