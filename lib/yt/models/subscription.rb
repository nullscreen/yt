require 'yt/models/base'

module Yt
  module Models
    # @private
    # Provides methods to interact with YouTube subscriptions.
    # @see https://developers.google.com/youtube/v3/docs/subscriptions
    class Subscription < Base
      # @return [String] the ID that uniquely identify a YouTube subscription.
      attr_reader :id

      def initialize(options = {})
        @id = options[:id]
        @auth = options[:auth]
      end

      def delete(options = {}, &block)
        do_delete {@id = nil}
        !exists?
      end

      def exists?
        !@id.nil?
      end

    private

      # @return [Hash] the parameters to submit to YouTube to delete a subscription.
      # @see https://developers.google.com/youtube/v3/docs/subscriptions/delete
      def delete_params
        super.tap do |params|
          params[:path] = '/youtube/v3/subscriptions'
          params[:params] = {id: @id}
        end
      end
    end
  end
end