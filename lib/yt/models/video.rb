require 'yt/models/resource'

module Yt
  module Models
    # Provides methods to interact with YouTube videos.
    # @see https://developers.google.com/youtube/v3/docs/videos
    class Video < Resource
      delegate :channel_id, :channel_title, :category_id,
        :live_broadcast_content, to: :snippet

      delegate :deleted?, :failed?, :processed?, :rejected?, :uploaded?,
        :uses_unsupported_codec?, :has_failed_conversion?, :empty?, :invalid?,
        :too_small?, :aborted?, :claimed?, :infringes_copyright?, :duplicate?,
        :scheduled_at, :publish_at, :scheduled?, :too_long?, :violates_terms_of_use?,
        :inappropriate?, :infringes_trademark?, :belongs_to_closed_account?,
        :belongs_to_suspended_account?, :licensed_as_creative_commons?,
        :licensed_as_standard_youtube?, :has_public_stats_viewable?,
        :public_stats_viewable, :embeddable, :embeddable?, :license, to: :status

      # @!attribute [r] content_detail
      #   @return [Yt::Models::ContentDetail] the video’s content details.
      has_one :content_detail
      delegate :duration, :hd?, :stereoscopic?, :captioned?, :licensed?,
        to: :content_detail

      # @!attribute [r] rating
      #   @return [Yt::Models::Rating] the video’s rating.
      has_one :rating

      # @!attribute [r] live_streaming_detail
      #   @return [Yt::Models::LiveStreamingDetail] live streaming detail.
      has_one :live_streaming_detail
      delegate :actual_start_time, :actual_end_time, :scheduled_start_time,
        :scheduled_end_time, :concurrent_viewers, to: :live_streaming_detail

      # @!attribute [r] annotations
      #   @return [Yt::Collections::Annotations] the video’s annotations.
      has_many :annotations

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
      delegate :view_count, :like_count, :dislike_count, :favorite_count,
        :comment_count, to: :statistics_set

      # Returns the list of keyword tags associated with the video.
      # Since YouTube API only returns tags on Videos#list, the memoized
      # @snippet is erased if the video was instantiated through Video#search
      # (e.g., by calling account.videos or channel.videos), so that the full
      # snippet (with tags) is loaded, rather than the partial one.
      # @see https://developers.google.com/youtube/v3/docs/videos
      # @return [Array<Yt::Models::Tag>] the list of keyword tags associated
      #   with the video.
      def tags
        if @auth
          @snippet = nil unless snippet.includes_tags
          snippet.tags
        else
          []
        end
      end

      # Deletes the video.
      #
      # This method requires {Resource#auth auth} to return an authenticated
      # instance of {Yt::Account} with permissions to delete the video.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an account with permissions to delete the video.
      # @return [Boolean] whether the video does not exist anymore.
      def delete(options = {})
        do_delete {@id = nil}
        !exists?
      end

      def exists?
        !@id.nil?
      end

      # Returns whether the authenticated account likes the video.
      #
      # This method requires {Resource#auth auth} to return an
      # authenticated instance of {Yt::Account}.
      # @return [Boolean] whether the account likes the video.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an authenticated account.
      def liked?
        rating.rating == :like
      end

      # Likes the video on behalf of the authenticated account.
      #
      # This method requires {Resource#auth auth} to return an
      # authenticated instance of {Yt::Account}.
      # @return [Boolean] whether the account likes the video.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an authenticated account.
      def like
        rating.set :like
        liked?
      end

      # Dislikes the video on behalf of the authenticated account.
      #
      # This method requires {Resource#auth auth} to return an
      # authenticated instance of {Yt::Account}.
      # @return [Boolean] whether the account does not like the video.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an authenticated account.
      def dislike
        rating.set :dislike
        !liked?
      end

      # Resets the rating of the video on behalf of the authenticated account.
      #
      # This method requires {Resource#auth auth} to return an
      # authenticated instance of {Yt::Account}.
      # @return [Boolean] whether the account does not like the video.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an authenticated account.
      def unlike
        rating.set :none
        !liked?
      end

      # @private
      # Tells `has_reports` to retrieve the reports from YouTube Analytics API
      # either as a Channel or as a Content Owner.
      # @see https://developers.google.com/youtube/analytics/v1/reports
      def reports_params
        {}.tap do |params|
          if auth.owner_name
            params['ids'] = "contentOwner==#{auth.owner_name}"
          else
            params['ids'] = "channel==#{channel_id}"
          end
          params['filters'] = "video==#{id}"
        end
      end

    private

      # @see https://developers.google.com/youtube/v3/docs/videos/update
      # @todo: Add recording details keys
      def update_parts
        snippet_keys = [:title, :description, :tags, :category_id]
        snippet = {keys: snippet_keys, sanitize_brackets: true}
        status_keys = [:privacy_status, :embeddable, :license,
          :public_stats_viewable, :publish_at]
        {snippet: snippet, status: {keys: status_keys}}
      end
    end
  end
end