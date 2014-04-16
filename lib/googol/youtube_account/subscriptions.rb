module Googol
  # Separate module to group YoutubeAccount methods related to subscriptions.
  module Subscriptions
    # Subscribe a Youtube account to a channel
    #
    # @param [Hash] target The target of the 'subscribe' activity
    # @option target [String] :channel_id The ID of the channel to subscribe to
    #
    # @see https://developers.google.com/youtube/v3/docs/subscriptions/insert
    #
    def subscribe_to!(target = {})
      channel_id = fetch! target, :channel_id
      youtube_request! path: '/subscriptions?part=snippet', json: true,
        method: :post, body: {snippet: {resourceId: {channelId: channel_id}}}
    rescue Googol::RequestError => e
      raise e unless e.to_s =~ /subscriptionDuplicate/
    end
  end
end