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

      # @return [Yt::Models::Video] a new video initialized with one of
      #   the items returned by asking YouTube for a list of videos.
      # According to the documentation, tags are only visible to the video's
      # uploader, and are not returned when search for all the videos of an
      # account. Instead, a separate call to Videos#list is required. Setting
      # +includes_tags+ to +false+ makes sure that `video.tags` will do this.
      # @see https://developers.google.com/youtube/v3/docs/videos#resource
      def new_item(data)
        snippet = data.fetch('snippet', {}).merge includes_tags: false
        Yt::Video.new id: data['id']['videoId'], snippet: snippet, auth: @auth
      end

      # @return [Hash] the parameters to submit to YouTube to list videos.
      # @see https://developers.google.com/youtube/v3/docs/search/list
      def list_params
        super.tap do |params|
          params[:params] = videos_params
          params[:path] = '/youtube/v3/search'
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
          params[:order] ||= 'date'
          params[:published_before] = @published_before if @published_before
          params.merge! @parent.videos_params if @parent
          apply_where_params! params
        end
      end
    end
  end
end
