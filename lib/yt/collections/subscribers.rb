require 'yt/collections/subscribed_channels'

module Yt
  module Collections
    # Provides methods to interact with subscribers of a YouTube resource.
    #
    # Resources with subscribers are: {Yt::Models::Account accounts}.
    #
    # Confusingly, YouTube API provides the +same+ endpoint to either
    # retrieve the channels that you are subscribed to or the channels
    # that are subscribed to you. The difference relies in the setting the
    # +mySubscribers+ parameter to true and in reading the information
    # from the +subscriberSnippet+ part, not the +snippet+ part.
    # @see https://developers.google.com/youtube/v3/docs/subscriptions/list
    class Subscribers < SubscribedChannels

    private

      def attributes_for_new_item(data)
        snippet = data.fetch 'subscriberSnippet', {}
        {id: snippet['channelId'], snippet: snippet, auth: @auth}
      end

      def channels_params
        {}.tap do |params|
          params[:max_results] = 50
          params[:part] = 'subscriberSnippet'
          params[:my_subscribers] = true
        end
      end
    end
  end
end