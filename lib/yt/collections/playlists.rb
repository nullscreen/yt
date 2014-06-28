require 'yt/collections/resources'

module Yt
  module Collections
    class Playlists < Resources

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

    private

      # @return [Hash] the parameters to submit to YouTube to list playlists.
      # @see https://developers.google.com/youtube/v3/docs/playlist/list
      def list_params
        super.tap{|params| params[:params].merge! channelId: @parent.id}
      end
    end
  end
end