require 'yt/collections/resources'

module Yt
  module Collections
    class PlaylistItems < Resources

      def insert(attributes = {}, options = {})
        super attributes.merge(playlist_id: @parent.id), options
      rescue Yt::Error => error
        ignorable_errors = error.reasons & ['videoNotFound', 'forbidden']
        raise error unless options[:ignore_errors] && ignorable_errors.any?
      end

    private

      # @return [Hash] the parameters to submit to YouTube to list playlist items.
      # @see https://developers.google.com/youtube/v3/docs/playlistItems/list
      def list_params
        super.tap{|params| params[:params] = playlist_items_params}
      end

      def playlist_items_params
        resources_params.merge playlist_id: @parent.id
      end

      def insert_parts
        {snippet: {keys: [:playlist_id, :resource_id]}}
      end
    end
  end
end