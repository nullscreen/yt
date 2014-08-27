require 'yt/collections/base'
require 'yt/models/video'

module Yt
  module Collections
    # Provides methods to interact with a collection of YouTube videos.
    #
    # Resources with videos are: {Yt::Models::Channel channels} and
    # {Yt::Models::Account accounts}.
    class Videos < Base

    private

      def attributes_for_new_item(data)
        snippet = data.fetch('snippet', {})
        snippet.merge!(includes_tags: false) if tags_hidden?

        if search_videos?
          {id: data['id']['videoId'], snippet: snippet, auth: @auth}
        else
          {id: data['id'], snippet: snippet, auth: @auth}
        end
      end

      # @return [Hash] the parameters to submit to YouTube to list videos.
      # @see https://developers.google.com/youtube/v3/docs/search/list
      def list_params
        super.tap do |params|
          params[:params] = videos_params
          params[:path] = videos_path
        end
      end

      def next_page
        super.tap{|items| add_offset_to(items) if @page_token.nil?}
      end

      # According to http://stackoverflow.com/a/23256768 YouTube does not
      # provide more than 500 results for any query. In order to overcome
      # that limit, the query is restarted with a publishedBefore filter in
      # case there are more videos to be listed for a channel
      def add_offset_to(items)
        if items.count == videos_params[:max_results]
          last_published = items.last['snippet']['publishedAt']
          @page_token, @published_before = '', last_published
        end
      end

      def videos_params
        {}.tap do |params|
          params[:type] = :video
          params[:max_results] = 50
          params[:part] = 'snippet'
          params[:order] = 'date'
          params[:published_before] = @published_before if @published_before
          params.merge! @parent.videos_params if @parent
          apply_where_params! params
        end
      end

      # @private
      # @todo: This is one of two places outside of base.rb where @where_params
      #   is accessed; it should be replaced with a filter on params instead.
      # @see https://developers.google.com/youtube/v3/docs/videos/list
      def videos_path
        @where_params ||= {}
        if search_videos?
          '/youtube/v3/search'
        else
          '/youtube/v3/videos'
        end
      end

      def search_videos?
        @parent.present? || (@where_params.keys & [:id, :chart]).empty?
      end

      # Tags are only visible if through the Videos#list method, and only through
      # an authorized request.  If both of these conditions are met then the
      # response will include tags if they are accessible to you.
      def tags_hidden?
        @auth.blank? || search_videos?
      end
    end
  end
end