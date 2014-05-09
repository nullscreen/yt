require 'yt/collections/base'
require 'yt/models/playlist_item'

module Yt
  module Collections
    class PlaylistItems < Base

      def initialize(options = {})
        @playlist = options[:playlist]
        @auth = options[:auth]
      end

      def self.by_playlist(playlist)
        new playlist: playlist, auth: playlist.auth
      end

      # options are id and kind
      def insert(options = {}) #
        resource = {kind: "youtube##{options[:kind]}"}
        resource["#{options[:kind]}Id"] = options[:id]
        snippet = {playlistId: @playlist.id, resourceId: resource}
        do_insert body: {snippet: snippet}, params: {part: 'snippet,status'}
      end

      def delete_all(params = {})
        do_delete_all params
      end

    private

      def new_item(data)
        Yt::PlaylistItem.new id: data['id'], snippet: data['snippet'], status: data['status'], auth: @auth
      end

      def list_params
        super.tap do |params|
          params[:params] = {maxResults: 50, part: 'snippet,status', playlistId: @playlist.id}
          params[:scope] = 'https://www.googleapis.com/auth/youtube.readonly'
          params[:path] = '/youtube/v3/playlistItems'
        end
      end

      def insert_params
        super.tap do |params|
          params[:path] = '/youtube/v3/playlistItems'
        end
      end
    end
  end
end