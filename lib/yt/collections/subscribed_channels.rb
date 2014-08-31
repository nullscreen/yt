require 'yt/collections/channels'

module Yt
  module Collections
    # Provides methods to interact with the list of channels a resource is
    # subscribed to.
    #
    # Resources with subscribed channels are: {Yt::Models::Channel channels}.
    #
    class SubscribedChannels < Channels

    private

      def attributes_for_new_item(data)
        snippet = data.fetch 'snippet', {}
        resource = snippet.fetch 'resourceId', {}
        {id: resource['channelId'], snippet: snippet, auth: @auth}
      end

      # @return [Hash] the parameters to submit to YouTube to list subscribers.
      # @see https://developers.google.com/youtube/v3/docs/subscriptions/list
      def list_params
        super.tap{|params| params[:path] = '/youtube/v3/subscriptions'}
      end

      # @private
      # @note Subscribers overwrites +channel_params+ since the query
      #   is slightly different.
      def channels_params
        {}.tap do |params|
          params[:max_results] = 50
          params[:part] = 'snippet'
          params[:channel_id] = @parent.id
          apply_where_params! params
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