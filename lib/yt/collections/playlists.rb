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

      def attributes_for_new_item(data)
        super.merge content_details: data['contentDetails']
      end

      def eager_load_items_from(items)
        if included_relationships.any?
          ids = items.map{|item| item['id']}
          parts = included_relationships.map{|r| r.to_s.camelize(:lower)}
          conditions = {id: ids.join(','), part: parts.join(',')}
          playlists = Collections::Playlists.new(auth: @auth).where conditions

          items.each do |item|
            playlist = playlists.find{|playlist| playlist.id == item['id']}
            parts.each do |part|
              item[part] = case part
                when 'snippet' then playlist.snippet.data.merge complete: true
                when 'contentDetails' then playlist.content_detail.data
              end
            end if playlist
          end
        end
        super
      end

      def insert_parts
        snippet = {keys: [:title, :description, :tags], sanitize_brackets: true}
        status = {keys: [:privacy_status]}
        {snippet: snippet, status: status}
      end
    end
  end
end