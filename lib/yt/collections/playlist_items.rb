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

      def attributes_for_new_item(data)
        snippet = data.fetch 'snippet', {}
        data['snippet'].reverse_merge! complete: snippet.key?('position')
        super(data)
      end

      # @return [Hash] the parameters to submit to YouTube to list playlist items.
      # @see https://developers.google.com/youtube/v3/docs/playlistItems/list
      def list_params
        super.tap{|params| params[:params] = playlist_items_params}
      end

      def playlist_items_params
        resources_params.merge playlist_id: @parent.id
      end

      def insert_parts
        {snippet: {keys: [:playlist_id, :resource_id, :position]}}
      end
    end
  end
end