require 'yt/models/resource'

module Yt
  module Models
    # Provides methods to interact with YouTube videos.
    # @see https://developers.google.com/youtube/v3/docs/videos
    class Video < Resource

  ### SNIPPET ###

      # @!attribute [r] title
      # @return [String] the video’s title. Has a maximum of 100 characters and
      #   may contain all valid UTF-8 characters except < and >.
      delegate :title, to: :snippet

      # @!attribute [r] description
      # @return [String] the video’s description. Has a maximum of 5000 bytes
      #   and may contain all valid UTF-8 characters except < and >.
      delegate :description, to: :snippet

      # Return the URL of the video’s thumbnail.
      # @!method thumbnail_url(size = :default)
      # @param [Symbol, String] size The size of the video’s thumbnail.
      # @return [String] if +size+ is +default+, the URL of a 120x90px image.
      # @return [String] if +size+ is +medium+, the URL of a 320x180px image.
      # @return [String] if +size+ is +high+, the URL of a 480x360px image.
      # @return [nil] if the +size+ is not +default+, +medium+ or +high+.
      delegate :thumbnail_url, to: :snippet

      # @!attribute [r] published_at
      # @return [Time] the date and time that the video was published.
      delegate :published_at, to: :snippet

      # @!attribute [r] channel_id
      # @return [String] the ID of the channel that the video belongs to.
      delegate :channel_id, to: :snippet

      # @!attribute [r] channel_title
      # @return [String] the title of the channel that the video belongs to.
      delegate :channel_title, to: :snippet

      # @!attribute [r] live_broadcast_content
      # @return [String] the type of live broadcast that the video contains.
      #   Valid values are: live, none, upcoming.
      delegate :live_broadcast_content, to: :snippet

      # @return [Array<Yt::Models::Tag>] the list of tags attached to the video.
      #   with the video.
      def tags
        ensure_complete_snippet :tags
      end

      # @return [String] ID of the YouTube category associated with the video.
      def category_id
        ensure_complete_snippet :category_id
      end

    ### STATUS ###

      # @return [Boolean] whether the video was deleted by the user.
      def deleted?
        status.upload_status == 'deleted'
      end

      # @return [Boolean] whether the video failed to upload.
      def failed?
        status.upload_status == 'failed'
      end

      # @return [Boolean] whether the video has been fully processed by YouTube.
      def processed?
        status.upload_status == 'processed'
      end

      # @return [Boolean] whether the video was rejected by YouTube.
      def rejected?
        status.upload_status == 'rejected'
      end

      # @return [Boolean] whether the video is being uploaded to YouTube.
      def uploading?
        status.upload_status == 'uploaded'
      end

      # @deprecated Use {#uploading?} instead.
      # @return [Boolean] whether the video is being uploaded to YouTube.
      def uploaded?
        uploading?
      end

      # @return [Boolean] whether the video failed to upload to YouTube because
      #   of an unsupported codec.
      # @see https://support.google.com/youtube/answer/1722171
      def uses_unsupported_codec?
        status.failure_reason == 'codec'
      end

      # @return [Boolean] whether the video failed to upload to YouTube because
      #   YouTube was unable to convert the video.
      def has_failed_conversion?
        status.failure_reason == 'conversion'
      end

      # @return [Boolean] whether the video failed to upload to YouTube because
      #   the video file is empty.
      def empty?
        status.failure_reason == 'emptyFile'
      end

      # @return [Boolean] whether the video failed to upload to YouTube because
      #   the video uses an unsupported file format.
      # @see https://support.google.com/youtube/troubleshooter/2888402?hl=en
      def invalid?
        status.failure_reason == 'invalidFile'
      end

      # @return [Boolean] whether the video failed to upload to YouTube because
      #   the video file is too small for YouTube.
      def too_small?
        status.failure_reason == 'tooSmall'
      end

      # @return [Boolean] whether the video failed to upload to YouTube because
      #   the uploading process was aborted.
      def aborted?
        status.failure_reason == 'uploadAborted'
      end

      # @return [Boolean] whether the video was rejected by YouTube because
      #   the video was claimed by a different account.
      def claimed?
        status.rejection_reason == 'claim'
      end

      # @return [Boolean] whether the video was rejected by YouTube because
      #   the video commits a copyright infringement.
      def infringes_copyright?
        status.rejection_reason == 'copyright'
      end

      # @return [Boolean] whether the video was rejected by YouTube because
      #   the video is a duplicate of another video.
      def duplicate?
        status.rejection_reason == 'duplicate'
      end

      # @return [Boolean] whether the video was rejected by YouTube because
      #   the video contains inappropriate content.
      def inappropriate?
        status.rejection_reason == 'inappropriate'
      end

      # @return [Boolean] whether the video was rejected by YouTube because
      #   the video exceeds the maximum duration for YouTube.
      # @see https://support.google.com/youtube/answer/71673?hl=en
      def too_long?
        status.rejection_reason == 'length'
      end

      # @return [Boolean] whether the video was rejected by YouTube because
      #   the video violates the Terms of Use.
      def violates_terms_of_use?
        status.rejection_reason == 'termsOfUse'
      end

      # @return [Boolean] whether the video was rejected by YouTube because
      #   the video infringes a trademark.
      # @see https://support.google.com/youtube/answer/2801979?hl=en
      def infringes_trademark?
        status.rejection_reason == 'trademark'
      end

      # @return [Boolean] whether the video was rejected by YouTube because
      #   the account that uploaded the video has been closed.
      def belongs_to_closed_account?
        status.rejection_reason == 'uploaderAccountClosed'
      end

      # @return [Boolean] whether the video was rejected by YouTube because
      #   the account that uploaded the video has been suspended.
      def belongs_to_suspended_account?
        status.rejection_reason == 'uploaderAccountSuspended'
      end

      # Returns the time when a video is scheduled to be published.
      # @return [Time] if the video is scheduled to be published, the time
      #   when it will become public.
      # @return [nil] if the video is not scheduled to be published.
      def scheduled_at
        status.publish_at if scheduled?
      end

      # @return [Boolean] whether the video is scheduled to be published.
      def scheduled?
        private? && status.publish_at
      end

      # @!attribute [r] license
      # @return [String] the video’s license.
      #   Valid values are: creativeCommon, youtube.
      delegate :license, to: :status

      # @return [Boolean] whether the video uses the Standard YouTube license.
      # @see https://www.youtube.com/static?template=terms
      def licensed_as_standard_youtube?
        license == 'youtube'
      end

      # @return [Boolean] whether the video uses a Creative Commons license.
      # @see https://support.google.com/youtube/answer/2797468?hl=en
      def licensed_as_creative_commons?
        license == 'creativeCommon'
      end

      # Returns whether the video statistics are publicly viewable.
      # @return [Boolean] if the resource is a video, whether the extended
      #   video statistics on the video’s watch page are publicly viewable.
      #   By default, those statistics are viewable, and statistics like a
      #   video’s viewcount and ratings will still be publicly visible even
      #   if this property’s value is set to false.
      def has_public_stats_viewable?
        status.public_stats_viewable
      end

      # @return [Boolean] whether the video can be embedded on another website.
      def embeddable?
        status.embeddable
      end

    ### CONTENT DETAILS ###

      has_one :content_detail

      # @!attribute [r] duration
      # @return [Integer] the duration of the video (in seconds).
      delegate :duration, to: :content_detail

      # @return [Boolean] whether the video is available in 3D.
      def stereoscopic?
        content_detail.dimension == '3d'
      end

      # @return [Boolean] whether the video is available in high definition.
      def hd?
        content_detail.definition == 'hd'
      end

      # @return [Boolean] whether captions are available for the video.
      def captioned?
        content_detail.caption == 'true'
      end

      # @return [Boolean] whether the video represents licensed content, which
      #   means that the content has been claimed by a YouTube content partner.
      def licensed?
        content_detail.licensed_content || false
      end

    ### FILE DETAILS ###

      has_one :file_detail

      # @!attribute [r] file_size
      # @return [Integer] the size of the uploaded file (in bytes).
      delegate :file_size, to: :file_detail

      # @!attribute [r] file_type
      # @return [String] the type of file uploaded. May be one of:
      #   archive, audio, document, image, other, project, video.
      delegate :file_type, to: :file_detail

      # @!attribute [r] container
      # @return [String] the video container of the uploaded file. (e.g. 'mov').
      delegate :container, to: :file_detail


    ### RATING ###

      has_one :rating

      # @return [Boolean] whether the authenticated account likes the video.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} is not an
      #   authenticated Yt::Account.
      def liked?
        rating.rating == :like
      end

      # Likes the video on behalf of the authenticated account.
      # @return [Boolean] whether the authenticated account likes the video.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} is not an
      #   authenticated Yt::Account.
      def like
        rating.set :like
        liked?
      end

      # Dislikes the video on behalf of the authenticated account.
      # @return [Boolean] whether the account does not like the video.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} is not an
      #   authenticated Yt::Account.
      def dislike
        rating.set :dislike
        !liked?
      end

      # Resets the rating of the video on behalf of the authenticated account.
      # @return [Boolean] whether the account does not like the video.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} is not an
      #   authenticated Yt::Account.
      def unlike
        rating.set :none
        !liked?
      end

    ### VIDEO CATEGORY ###

      has_one :video_category

      # @return [String] the video category’s title.
      def category_title
        video_category.title
      end

      has_one :advertising_options_set
      delegate :ad_formats, to: :advertising_options_set

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
      # @note: This is not the total number of subscribers gained by the video’s
      #        channel, but the subscribers gained *from* the video’s page.
      has_report :subscribers_gained

      # @macro has_report
      # @note: This is not the total number of subscribers lost by the video’s
      #        channel, but the subscribers lost *from* the video’s page.
      has_report :subscribers_lost

      # @macro has_report
      has_report :favorites_added

      # @macro has_report
      has_report :favorites_removed

      # @macro has_report
      has_report :estimated_minutes_watched

      # @macro has_report
      has_report :average_view_duration

      # @macro has_report
      has_report :average_view_percentage

      # @macro has_report
      has_report :impressions

      # @macro has_report
      has_report :monetized_playbacks

      # @macro has_report
      has_report :annotation_clicks

      # @macro has_report
      has_report :annotation_click_through_rate

      # @macro has_report
      has_report :annotation_close_rate

      # @macro has_report
      has_report :viewer_percentage

      # @deprecated Use {#has_report :viewer_percentage}.
      # @macro has_viewer_percentages
      has_viewer_percentages

      # @!attribute [r] statistics_set
      #   @return [Yt::Models::StatisticsSet] the statistics for the video.
      has_one :statistics_set
      delegate :view_count, :like_count, :dislike_count, :favorite_count,
        :comment_count, to: :statistics_set

      # @!attribute [r] player
      #   @return [Yt::Models::Player] the player for the video.
      has_one :player
      delegate :embed_html, to: :player

      # @!attribute [r] resumable_sessions
      #   @return [Yt::Collections::ResumableSessions] the sessions used to
      #     upload thumbnails using the resumable upload protocol.
      has_many :resumable_sessions

      # Override Resource's new to set statistics and content details as well
      # if the response includes them
      def initialize(options = {})
        super options
        if options[:statistics]
          @statistics_set = StatisticsSet.new data: options[:statistics]
        end
        if options[:content_details]
          @content_detail = ContentDetail.new data: options[:content_details]
        end
        if options[:file_details]
          @file_detail = FileDetail.new data: options[:file_details]
        end
        if options[:video_category]
          @video_category = VideoCategory.new data: options[:video_category]
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


      # Uploads a thumbnail
      # @param [String] path_or_url the image to upload. Can either be the
      #   path of a local file or the URL of a remote file.
      # @return the new thumbnail resource for the given image.
      # @raise [Yt::Errors::RequestError] if path_or_url is not a valid path
      #   or URL.
      # @see https://developers.google.com/youtube/v3/docs/thumbnails#resource
      def upload_thumbnail(path_or_url)
        file = open(path_or_url, 'rb') rescue StringIO.new
        session = resumable_sessions.insert file.size

        session.update(body: file) do |data|
          snippet.instance_variable_set :@thumbnails, data['items'].first
        end
      end

      # @private
      # Tells `has_reports` to retrieve the reports from YouTube Analytics API
      # either as a Channel or as a Content Owner.
      # @see https://developers.google.com/youtube/analytics/v1/reports
      def reports_params
        {}.tap do |params|
          if auth.owner_name
            params[:ids] = "contentOwner==#{auth.owner_name}"
          else
            params[:ids] = "channel==#{channel_id}"
          end
          params[:filters] = "video==#{id}"
        end
      end

      # @private
      # Tells `has_many :resumable_sessions` what path to hit to upload a file.
      def upload_path
        '/upload/youtube/v3/thumbnails/set'
      end
      # @private
      # Tells `has_many :resumable_sessions` what params are set for the object
      # associated to the uploaded file.
      def upload_params
        {video_id: id}
      end

      # @private
      # Tells `has_many :resumable_sessions` what type of file can be uploaded.
      def upload_content_type
        'application/octet-stream'
      end

    private

      # Since YouTube API only returns tags on Videos#list, the memoized
      # `@snippet` is erased if the video was instantiated through Video#search
      # (e.g., by calling account.videos or channel.videos), so that the full
      # snippet (with tags and category) is loaded, rather than the partial one.
      def ensure_complete_snippet(attribute)
        unless snippet.public_send(attribute).present? || snippet.complete?
          @snippet = nil
        end
        snippet.public_send attribute
      end

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
