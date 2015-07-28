require 'yt/collections/resources'

module Yt
  module Collections
    class Playlists < Resources

    private

      # @return [Hash] the parameters to submit to YouTube to list channels.
      # @see https://developers.google.com/youtube/v3/docs/channels/list
      def list_params
        super.tap{|params| params[:params] = playlists_params}
      end

      def playlists_params
        params = resources_params
        params.merge! channel_id: @parent.id if @parent
        apply_where_params! params
      end

      def insert_parts
        snippet = {keys: [:title, :description, :tags], sanitize_brackets: true}
        status = {keys: [:privacy_status]}
        {snippet: snippet, status: status}
      end
    end
  end
end