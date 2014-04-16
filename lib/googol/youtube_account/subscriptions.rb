module Googol
  # Separate module to group YoutubeAccount methods related to subscriptions.
  module Subscriptions
    # Subscribe a Youtube account to a channel. If the account is already
    # subscribed, raise an error.
    #
    # @param [Hash] channel The channel for the 'subscribe' activity
    # @option channel [String] :channel_id The ID of the channel to subscribe to
    #
    # @return [String] The ID of the new channel subscription
    #
    # @see https://developers.google.com/youtube/v3/docs/subscriptions/insert
    #
    def subscribe_to!(channel = {})
      channel_id = fetch! channel, :channel_id
      youtube_request! path: '/subscriptions?part=snippet', json: true,
        method: :post, body: {snippet: {resourceId: {channelId: channel_id}}}
    end

    # Subscribe a Youtube account to a channel. If the account is already
    # subscribed, return the existing channel subscription ID.
    #
    # @param [Hash] channel The channel for the 'subscribe' activity
    # @option channel [String] :channel_id The ID of the channel to subscribe to
    #
    # @return [String] The ID of the new or existing channel subscription
    #
    # @raise [Googol::RequestError] if the subscription does not go through,
    #   unless the error is that the user is already subscribed to the channel.
    #
    # @see https://developers.google.com/youtube/v3/docs/subscriptions/insert
    #
    def subscribe_to(channel = {})
      subscribe_to! channel
    rescue Googol::RequestError => e
      if e.to_s =~ /subscriptionDuplicate/
        find_subscription_by channel
      else
        raise e
      end
    end

    # Unsubscribe a Youtube account from a channel. If the account is not
    # subscribed, raise an error.
    #
    # @param [Hash] channel The channel for the 'subscribe' activity
    # @option channel [String] :channel_id The ID of the channel to unsubscribe from
    #
    # @raise [Googol::RequestError] if the unsubscription does not go through
    #
    # @see https://developers.google.com/youtube/v3/docs/subscriptions/delete
    #
    def unsubscribe_from!(channel = {})
      delete_subscription!(find_subscription_by channel)
    end

    # Unsubscribe a Youtube account from a channel. If the account is not
    # subscribed, ignore the request.
    #
    # @param [Hash] channel The channel for the 'subscribe' activity
    # @option channel [String] :channel_id The ID of the channel to unsubscribe from
    #
    # @raise [Googol::RequestError] if the unsubscription does not go through,
    #   unless the error is that the user was not subscribed to the channel.
    #
    # @see https://developers.google.com/youtube/v3/docs/subscriptions/delete
    #
    def unsubscribe_from(channel = {})
      unsubscribe_from! channel
    rescue Googol::RequestError => e
      if e.to_s =~ /subscriptionNotFound/
        true
      else
        raise e
      end
    end

  private

    # Return the first subscription of the Youtube account for the given filters.
    #
    # @param [Hash] filters The channel subscribed to (plus private options)
    # @option filters [String] :channel_id The ID of the channel subscribed to
    # @option filters [Integer] :retries Number of retries is subscription not found
    #
    # @note Google API does not have a "search" endpoint, therefore we have
    # to scan the list of subscriptions page by page, limiting at 10 pages to
    # prevent this function from running forever (50 subscriptions per page).
    #
    # @note Google API must have some caching layer by which if we try to
    # delete a subscription that we just created, we encounter an error.
    # To overcome this, if we don't find a playlist, we can pass a +retries+
    # parameter to try the same request at intervals of 5 seconds.
    #
    # @return [String or nil] The ID of the subscription (or nil if not found)
    def find_subscription_by(filters = {})
      page = filters.delete(:page) || 1

      path = "/subscriptions?part=id,snippet&mine=true"
      path << "&maxResults=#{filters.delete(:max) || 50 }"
      path << "&pageToken=#{filters.delete :token}" if filters[:token]

      response = youtube_request! path: path
      items = response[:items]

      if subscription = items.find{|s| subscription_belongs_to? s, filters}
        subscription[:id]
      elsif page < 10 && token = response[:nextPageToken]
        find_subscription_by filters.merge page: page, token: token
      elsif filters.fetch(:retries, 0) > 0
        sleep 5 * filters[:retries]
        find_subscription_by filters.merge retries: filters[:retries] - 1
      end
    end

    # Checks if the subscription belongs to the given channel.
    #
    # @param [Hash] channel The channel the subscription might belong to
    # @option channel_id [String] The ID of the channel
    #
    # @example Given a subscription x with channel_id: 'ABCDE'
    #     subscription_belongs_to? x, channel_id: 'ABCDE' # => true
    #     subscription_belongs_to? x, channel_id: '12345' # => false
    #
    # @return [Boolean] Whether the subscription belongs to the channel
    def subscription_belongs_to?(subscription, channel = {})
      channel_id = fetch! channel, :channel_id
      subscription[:snippet][:resourceId][:channelId] == channel_id
    end

    # Delete a channel subscription for the Youtube account. If the
    # subscription does not exist, raise an error.
    #
    # @param [String] subscription_id The channel subscription ID to delete
    #
    # @raise [Googol::RequestError] if the unsubscription does not go through
    #
    # @see https://developers.google.com/youtube/v3/docs/subscriptions/delete
    #
    def delete_subscription!(subscription_id, retries = 5)
      youtube_request! method: :delete, code: 204,
        path: "/subscriptions?id=#{subscription_id}"
    end
  end
end