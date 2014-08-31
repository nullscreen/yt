require 'yt/models/resource'

module Yt
  module Models
    # A channel resource contains information about a YouTube channel.
    # @see https://developers.google.com/youtube/v3/docs/channels
    class Channel < Resource
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

      # @macro has_viewer_percentages
      has_viewer_percentages

      # @!attribute [r] statistics_set
      #   @return [Yt::Models::StatisticsSet] the statistics for the video.
      has_one :statistics_set
      delegate :view_count, :comment_count, :video_count, :subscriber_count,
        :subscriber_count_visible?, to: :statistics_set

      # @!attribute [r] content_owner_detail
      #   @return [Yt::Models::ContentOwnerDetail] the video’s content owner
      #     details.
      has_one :content_owner_detail
      delegate :content_owner, :linked_at, to: :content_owner_detail

      # @!attribute [r] subscribed_channels
      #   @return [Yt::Collections::SubscribedChannels] the channels that the channel is subscribed to.
      #   @raise [Yt::Errors::Forbidden] if the owner of the channel has
      #     explicitly select the option to keep all subscriptions private.
      has_many :subscribed_channels

      # @!attribute [r] subscription
      #   @return [Yt::Models::Subscription] the channel’s subscription by auth.
      #   @raise [Yt::Errors::NoItems] if {Resource#auth auth} is not
      #     subscribed to the channel.
      #   @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #     return an authenticated account.
      has_one :subscription

      # Returns whether the authenticated account is subscribed to the channel.
      #
      # This method requires {Resource#auth auth} to return an
      # authenticated instance of {Yt::Account}.
      # @return [Boolean] whether the account is subscribed to the channel.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an authenticated account.
      def subscribed?
        sleep [(@subscriptions_updated_at || Time.now) - Time.now, 0].max
        subscription.exists?
      rescue Errors::NoItems
        false
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
        subscription.delete.tap{ throttle_subscriptions }
      end

      # Unsubscribes the authenticated account from the channel.
      # Does not raise an error if the account was not subscribed.
      #
      # This method requires {Resource#auth auth} to return an
      # authenticated instance of {Yt::Account}.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an authenticated account.
      def unsubscribe
        unsubscribe! if subscribed?
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
        subscriptions.insert.tap do |subscription|
          throttle_subscriptions
          @subscription = subscription
        end
      end

      # Subscribes the authenticated account to the channel.
      # Does not raise an error if the account was already subscribed.
      #
      # This method requires {Resource#auth auth} to return an
      # authenticated instance of {Yt::Account}.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an authenticated account.
      def subscribe
        subscriptions.insert(ignore_errors: true).tap do |subscription|
          throttle_subscriptions
          @subscription = subscription
        end
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
        {channel_id: id}
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

      # @private
      # Tells `has_one :content_owner_detail` to retrieve the content owner
      # detail as the Content Owner, it the channel was authorized with one.
      # If it was not, the call will fail, since YouTube only allows content
      # owners to check who is the content owner of a channel.
      def content_owner_details_params
        {on_behalf_of_content_owner: auth.owner_name || auth.id}
      end

      # @private
      # @note Google API must have some caching layer by which if we try to
      # delete a subscription that we just created, we encounter an error.
      # To overcome this, if we have just updated the subscription, we must
      # wait some time before requesting it again.
      def throttle_subscriptions(seconds = 10)
        @subscriptions_updated_at = Time.now + seconds
      end
    end
  end
end