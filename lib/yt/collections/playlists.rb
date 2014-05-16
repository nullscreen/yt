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

      def new_item(data)
        Yt::Playlist.new id: data['id'], snippet: data['snippet'], status: data['status'], auth: @auth
      end

      def list_params
        super.tap do |params|
          params[:params] = {maxResults: 50, part: 'snippet,status', channelId: @parent.id}
        end
      end

      def insert_params
        super.tap do |params|
          params[:path] = '/youtube/v3/playlists'
        end
      end
    end
  end
end