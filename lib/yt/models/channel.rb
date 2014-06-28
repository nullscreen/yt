require 'yt/models/resource'

module Yt
  module Models
    # A channel resource contains information about a YouTube channel.
    # @see https://developers.google.com/youtube/v3/docs/channels
    class Channel < Resource
      # @!attribute [r] subscriptions
      #   @return [Yt::Collections::Subscriptions] the channel’s subscriptions.
      has_many :subscriptions

      # @!attribute [r] videos
      #   @return [Yt::Collections::Videos] the channel’s videos.
      has_many :videos

      # @!attribute [r] playlists
      #   @return [Yt::Collections::Playlists] the channel’s playlists.
      has_many :playlists

      # @macro has_report
      has_report :earnings

      # @macro has_report
      has_report :views

      # @macro has_report
      has_report :comments

      # @macro has_report
      has_report :likes

      # @macro has_report
      has_report :dislikes

      # @macro has_report
      has_report :shares

      # @macro has_report
      has_report :impressions

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

      # @private
      # Tells `has_reports` to retrieve the reports from YouTube Analytics API
      # either as a Channel or as a Content Owner.
      # @see https://developers.google.com/youtube/analytics/v1/reports
      def reports_params
        {}.tap do |params|
          if auth.owner_name
            params['ids'] = "contentOwner==#{auth.owner_name}"
            params['filters'] = "channel==#{id}"
          else
            params['ids'] = "channel==#{id}"
          end
        end
      end
    end
  end
end