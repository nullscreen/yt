require 'yt/collections/channels'
require 'yt/models/channel'

module Yt
  module Collections
    class Subscribers < Channels

    private

      def attributes_for_new_item(data)
        snippet = data.fetch 'subscriberSnippet', {}
        {id: snippet['channelId'], snippet: snippet, auth: @auth}
      end

      # @return [Hash] the parameters to submit to YouTube to list subscribers.
      # @see https://developers.google.com/youtube/v3/docs/channels/list
      def list_params
        super.tap{|params| params[:path] = '/youtube/v3/subscriptions'}
      end

      # @private
      # @note Subscribers overwrites +channel_params+ since the query
      #   is slightly different.
      def channels_params
        {}.tap do |params|
          params[:max_results] = 50
          params[:part] = 'subscriberSnippet'
          params[:my_subscribers] = true
        end
      end

      # @private
      # @note Subscribers overwrites +list_resources+ since the objects to
      #   instatiate belongs to Channel class not Subscriber.
      def resource_class
        Yt::Models::Channel
      end
    end
  end
end