require 'yt/collections/base'
require 'yt/models/playlist'

module Yt
  module Collections
    class Playlists < Base

      # Valid body (no defaults) are: title (string), description (string), privacy_status (string),
      # tags (array of strings)
      def insert(options = {})
        body = {}

        snippet = options.slice :title, :description, :tags
        body[:snippet] = snippet if snippet.any?

        status = options[:privacy_status]
        body[:status] = {privacyStatus: status} if status

        do_insert body: body, params: {part: 'snippet,status'}
      end

      def delete_all(params = {})
        do_delete_all params
      end

    private

      # @return [Yt::Models::Playlist] a new playlist initialized with
      #   one of the items returned by asking YouTube for a list of playlists.
      # @see https://developers.google.com/youtube/v3/docs/playlists#resource
      def new_item(data)
        Yt::Playlist.new id: data['id'], snippet: data['snippet'], status: data['status'], auth: @auth
      end

      # @return [Hash] the parameters to submit to YouTube to list playlists.
      # @see https://developers.google.com/youtube/v3/docs/playlist/list
      def list_params
        super.tap do |params|
          params[:params] = {maxResults: 50, part: 'snippet,status', channelId: @parent.id}
        end
      end
    end
  end
end