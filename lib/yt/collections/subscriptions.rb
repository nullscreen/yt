require 'yt/collections/base'
require 'yt/models/subscription'

module Yt
  module Collections
    class Subscriptions < Base

      def insert(options = {})
        throttle
        do_insert
      rescue Yt::RequestError => error
        raise error unless options[:ignore_duplicates] && error.reasons.include?('subscriptionDuplicate')
      end

      def delete_all(params = {}, options = {})
        throttle
        do_delete_all params
      end

    private

      def new_item(data)
        Yt::Subscription.new id: data['id'], auth: @auth
      end

      # @note Google API must have some caching layer by which if we try to
      # delete a subscription that we just created, we encounter an error.
      # To overcome this, if we have just updated the subscription, we must
      # wait some time before requesting it again.
      #
      def throttle(seconds = 9)
        @last_changed_at ||= Time.now - seconds
        wait = [@last_changed_at - Time.now + seconds, 0].max
        sleep wait
        @last_changed_at = Time.now
      end

      def fetch_page(params = {})
        throttle
        super params
      end

      def list_params
        super.tap do |params|
          params[:params] = {maxResults: 50, forChannelId: @parent.id, mine: true, part: 'snippet'}
        end
      end

      def insert_params
        super.tap do |params|
          params[:path] = '/youtube/v3/subscriptions'
          params[:params] = {part: 'snippet'}
          params[:body] = {snippet: {resourceId: {channelId: @parent.id}}}
        end
      end
    end
  end
end