require 'yt/actions/delete_all'
require 'yt/actions/insert'
require 'yt/actions/list'
require 'yt/errors/request_error'

module Yt
  module Collections
    class Base
      include Actions::DeleteAll
      include Actions::Insert
      include Actions::List

      def initialize(options = {})
        @parent = options[:parent]
        @auth = options[:auth]
      end

      def self.of(parent)
        new parent: parent, auth: parent.auth
      end

      # Adds requirements to the collection in order to limit the result of
      # List methods to only items that match the requirements.
      #
      # Under the hood, all the requirements are passed to the YouTube API
      # as query parameters, after transforming the keys to camel-case.
      #
      # To know which requirements are available for each collection, check
      # the documentation of the corresponding YouTube API endpoint.
      # For instance the list of valid requirements to filter a list of videos
      # are at https://developers.google.com/youtube/v3/docs/search/list
      #
      # @example Return the first video of a channel (no requirements):
      #   channel.videos.first
      # @example Return the first long video of a channel by video count:
      #   channel.videos.where(order: 'viewCount', video_duration: 'long').first
      def where(requirements = {})
        self.tap do
          @items = []
          @where_params = requirements
        end
      end

      def includes(*relationships)
        self.tap do
          @items = []
          @included_relationships = relationships
        end
      end

    private

      def apply_where_params!(params = {})
        params.merge!(@where_params ||= {})
      end

      def included_relationships
        @included_relationships || []
      end
    end
  end
end
