require 'yt/collections/resources'

module Yt
  module Collections
    class PlaylistItems < Resources

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

    private

      # @return [Hash] the parameters to submit to YouTube to list items.
      # @see https://developers.google.com/youtube/v3/docs/playlistItems/list
      def list_params
        super.tap{|params| params[:params].merge! playlistId: @parent.id}
      end
    end
  end
end