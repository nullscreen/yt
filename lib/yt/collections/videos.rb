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
      # @see https://developers.google.com/youtube/v3/docs/videos#resource
      def new_item(data)
        Yt::Video.new id: data['id']['videoId'], snippet: data['snippet'], auth: @auth
      end

      # @return [Hash] the parameters to submit to YouTube to list videos.
      # @see https://developers.google.com/youtube/v3/docs/search/list
      def list_params
        super.tap do |params|
          params[:params] = @parent.videos_params.merge videos_params
          params[:path] = '/youtube/v3/search'
        end
      end

      def videos_params
        @extra_params ||= {}
        {type: :video, maxResults: 50, part: 'snippet'}.merge @extra_params
      end
    end
  end
end