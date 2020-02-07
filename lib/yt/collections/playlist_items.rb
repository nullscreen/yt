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
        super(data).tap do |attributes|
          attributes[:video] = data['video']
        end
      end

      def eager_load_items_from(items)
        if included_relationships.include?(:video)
          video_ids = items.map{|item| item['snippet']['resourceId']['videoId']}.uniq
          conditions = {id: video_ids.join(',')}
          conditions[:part] = 'snippet,status,statistics,contentDetails'
          videos = Collections::Videos.new(auth: @auth).where conditions
          items.each do |item|
            video = videos.find{|v| v.id == item['snippet']['resourceId']['videoId']}
            item['video'] = video
          end
        end
        super
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

      # For inserting a playlist item with content owner auth.
      # @see https://developers.google.com/youtube/v3/docs/playlistItems/insert
      def insert_params
        params = super
        params[:params] ||= {}
        params[:params].merge! @auth.insert_playlist_item_params
        params
      end
    end
  end
end
