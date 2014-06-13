require 'yt/collections/base'
require 'yt/models/subscription'

module Yt
  module Collections
    class Subscriptions < Base

      def insert(options = {})
        throttle
        do_insert
      rescue Yt::Error => error
        ignorable_errors = error.reasons & ['subscriptionDuplicate']
        raise error unless options[:ignore_errors] && ignorable_errors.any?
      end

      def delete_all(params = {}, options = {})
        throttle
        do_delete_all params
      end

    private

      # @return [Yt::Models::Subscription] a new subscription initialized with
      #   one of the items returned by asking YouTube for a list of
      #   subscriptions to a channel.
      # @see https://developers.google.com/youtube/v3/docs/subscriptions#resource
      def new_item(data)
        Yt::Subscription.new id: data['id'], auth: @auth
      end

      # @note Google API must have some caching layer by which if we try to
      # delete a subscription that we just created, we encounter an error.
      # To overcome this, if we have just updated the subscription, we must
      # wait some time before requesting it again.
      #
      def throttle(seconds = 11)
        @last_changed_at ||= Time.now - seconds
        wait = [@last_changed_at - Time.now + seconds, 0].max
        sleep wait
        @last_changed_at = Time.now
      end

      def fetch_page(params = {})
        throttle
        super params
      end

      # @return [Hash] the parameters to submit to YouTube to list subscriptions.
      # @see https://developers.google.com/youtube/v3/docs/subscriptions/list
      def list_params
        super.tap do |params|
          params[:params] = {maxResults: 50, forChannelId: @parent.id, mine: true, part: 'snippet'}
        end
      end

      # @return [Hash] the parameters to submit to YouTube to add a subscriptions.
      # @see https://developers.google.com/youtube/v3/docs/subscriptions/insert
      def insert_params
        super.tap do |params|
          params[:params] = {part: 'snippet'}
          params[:body] = {snippet: {resourceId: {channelId: @parent.id}}}
        end
      end
    end
  end
end