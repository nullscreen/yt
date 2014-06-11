require 'yt/models/resource'
require 'yt/associations/earnings'
require 'yt/associations/views'

module Yt
  module Models
    # Provides methods to interact with YouTube channels.
    # @see https://developers.google.com/youtube/v3/docs/channels
    class Channel < Resource
      include Associations::Earnings
      include Associations::Views

      # @!attribute subscriptions
      #   @return [Yt::Collections::Subscriptions] the channel’s subscriptions.
      has_many :subscriptions

      # @!attribute videos
      #   @return [Yt::Collections::Videos] the channel’s videos.
      has_many :videos

      # @!attribute playlists
      #   @return [Yt::Collections::Playlists] the channel’s playlists.
      has_many :playlists

      # Returns whether the authenticated account is subscribed to the channel.
      #
      # This method requires {Resource#auth auth} to return an
      # authenticated instance of {Yt::Account}.
      # @return [Boolean] whether the account is subscribed to the channel.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an authenticated account.
      def subscribed?
        subscriptions.any?{|s| s.exists?}
      end

      # Subscribes the authenticated account to the channel.
      # Does not raise an error if the account was already subscribed.
      #
      # This method requires {Resource#auth auth} to return an
      # authenticated instance of {Yt::Account}.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an authenticated account.
      def subscribe
        subscriptions.insert ignore_errors: true
      end

      # Subscribes the authenticated account to the channel.
      # Raises an error if the account was already subscribed.
      #
      # This method requires {Resource#auth auth} to return an
      # authenticated instance of {Yt::Account}.
      # @raise [Yt::Errors::RequestError] if {Resource#auth auth} was already
      #   subscribed to the channel.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an authenticated account.
      def subscribe!
        subscriptions.insert
      end

      # Unsubscribes the authenticated account from the channel.
      # Does not raise an error if the account was not subscribed.
      #
      # This method requires {Resource#auth auth} to return an
      # authenticated instance of {Yt::Account}.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an authenticated account.
      def unsubscribe
        subscriptions.delete_all({}, ignore_errors: true)
      end

      # Unsubscribes the authenticated account from the channel.
      # Raises an error if the account was not subscribed.
      #
      # This method requires {Resource#auth auth} to return an
      # authenticated instance of {Yt::Account}.
      # @raise [Yt::Errors::RequestError] if {Resource#auth auth} was not
      #   subscribed to the channel.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an authenticated account.
      def unsubscribe!
        subscriptions.delete_all
      end

      def create_playlist(params = {})
        playlists.insert params
      end

      def delete_playlists(attrs = {})
        playlists.delete_all attrs
      end

      def videos_params
        {channelId: id}
      end
    end
  end
end