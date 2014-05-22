require 'yt/collections/base'
require 'yt/models/playlist_item'

module Yt
  module Collections
    class PlaylistItems < Base

      # attrs are id and kind
      def insert(attrs = {}, options = {}) #
        resource = {kind: "youtube##{attrs[:kind]}"}
        resource["#{attrs[:kind]}Id"] = attrs[:id]
        snippet = {playlistId: @parent.id, resourceId: resource}
        do_insert body: {snippet: snippet}, params: {part: 'snippet,status'}
      rescue Yt::Error => error
        ignorable_errors = error.reasons & ['videoNotFound', 'forbidden']
        raise error unless options[:ignore_errors] && ignorable_errors.any?
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
          params[:params] = {maxResults: 50, part: 'snippet,status', playlistId: @parent.id}
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