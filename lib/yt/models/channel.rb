require 'yt/models/resource'
require 'yt/modules/reports'

module Yt
  module Models
    # A channel resource contains information about a YouTube channel.
    # @see https://developers.google.com/youtube/v3/docs/channels
    class Channel < Resource
      # Includes the +:has_report+ method to access YouTube Analytics reports.
      extend Modules::Reports

      # @!attribute [r] subscriptions
      #   @return [Yt::Collections::Subscriptions] the channel’s subscriptions.
      has_many :subscriptions

      # @!attribute [r] videos
      #   @return [Yt::Collections::Videos] the channel’s videos.
      has_many :videos

      # @!attribute [r] playlists
      #   @return [Yt::Collections::Playlists] the channel’s playlists.
      has_many :playlists

      # @!method earnings(options = {})
      #   @return [Hash<Date, Float>] the estimated earnings of the channel.
      #     Every key/value pair corresponds to the earnings in USD for a day.
      #   @param [Hash] options the range of days to get the earnings for.
      #   @option options [#to_date] :since The first day of the range.
      #     Also aliased as *:from*.
      #   @option options [#to_date] :until The last day of the range.
      #     Also aliased as *:to*.
      #
      # @!method earnings_on(date)
      #   @return [Float] the estimated earnings of the channel in USD.
      #   @param [#to_date] date The single day to get the earnings for.
      has_report :earnings

      # @!method views(options = {})
      #   @return [Hash<Date, Float>] the views of the channel.
      #     Every key/value pair corresponds to the views for a day.
      #   @param [Hash] options the range of days to get the views for.
      #   @option options [#to_date] :since The first day of the range.
      #     Also aliased as *:from*.
      #   @option options [#to_date] :until The last day of the range.
      #     Also aliased as *:to*.
      #
      # @!method views_on(date)
      #   @return [Float] the views of the channel.
      #   @param [#to_date] date The single day to get the views for.
      has_report :views

      # @!attribute [r] statistics_set
      #   @return [Yt::Models::StatisticsSet] the statistics for the video.
      has_one :statistics_set
      delegate :view_count, :comment_count, :video_count, :subscriber_count,
        :subscriber_count_visible?, to: :statistics_set

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

      # @private
      # Tells `has_many :videos` that channel.videos should return all the
      # videos publicly available on the channel.
      def videos_params
        {channelId: id}
      end
    end
  end
end