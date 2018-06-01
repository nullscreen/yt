require 'yt/collections/base'
require 'yt/models/subscription'

module Yt
  module Collections
    # @private
    class Subscriptions < Base

      def insert(options = {})
        do_insert
      rescue Yt::Error => error
        ignorable_error = error.reasons.include? 'subscriptionDuplicate'
        ignorable_error ||= (@parent.id == @auth.channel.id) if @auth
        raise error unless options[:ignore_errors] && ignorable_error
      end

    private

      def attributes_for_new_item(data)
        {id: data['id'], auth: @auth}
      end

      # @return [Hash] the parameters to submit to YouTube to list subscriptions.
      # @see https://developers.google.com/youtube/v3/docs/subscriptions/list
      def list_params
        super.tap do |params|
          params[:params] = subscriptions_params
        end
      end

      def subscriptions_params
        {}.tap do |params|
          params[:max_results] = 50
          params[:for_channel_id] = @parent.id
          params[:mine] = true
          params[:part] = 'snippet'
        end
      end

      # @return [Hash] the parameters to submit to YouTube to add a subscriptions.
      # @see https://developers.google.com/youtube/v3/docs/subscriptions/insert
      def insert_params
        super.tap do |params|
          params[:params] = {part: 'snippet'}
          params[:body] = {snippet: {resourceId: {channelId: @parent.id, kind: 'youtube#channel'}}}
        end
      end
    end
  end
end