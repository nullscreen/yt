require 'yt/collections/base'

module Yt
  module Collections
    class Resources < Base
      def delete_all(params = {})
        do_delete_all params
      end

    private

      # @return [resource_class] a new resource item initialized with
      #   one of the items returned by asking YouTube for a list of items.
      # @see https://developers.google.com/youtube/v3/docs/playlistItems#resource
      # @see https://developers.google.com/youtube/v3/docs/playlists#resource
      # @see https://developers.google.com/youtube/v3/docs/channels#resource
      def new_item(data)
        resource_class.new id: data['id'], snippet: data['snippet'], status: data['status'], auth: @auth
      end

      # @return [Hash] the parameters to submit to YouTube to list items.
      # @see https://developers.google.com/youtube/v3/docs/playlistItems/list
      # @see https://developers.google.com/youtube/v3/docs/playlists/list
      def list_params
        super.tap do |params|
          params[:params] = {maxResults: 50, part: 'snippet,status'}
        end
      end

      def resource_class
        resource_name = list_resources.name.demodulize.singularize
        require "yt/models/#{resource_name.underscore}"
        "Yt::Models::#{resource_name}".constantize
      end
    end
  end
end