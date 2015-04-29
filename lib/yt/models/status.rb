require 'yt/models/timestamp'

module Yt
  module Models
    # Contains information about the status of a resource. The details of the
    # status are different for the different types of resources.
    #
    # Resources with a
    # status are: channels, playlists, playlist items and videos.
    # @see https://developers.google.com/youtube/v3/docs/channels#resource
    # @see https://developers.google.com/youtube/v3/docs/videos#resource
    # @see https://developers.google.com/youtube/v3/docs/playlists#resource
    # @see https://developers.google.com/youtube/v3/docs/playlistItems#resource
    class Status < Base
      attr_reader :data

      def initialize(options = {})
        @data = options[:data]
      end

# Privacy status

      PRIVACY_STATUSES = %q(private public unlisted)

      # @return [String] the privacy status of the resource. Valid values are:
      #   private, public, unlisted.
      has_attribute :privacy_status

      # @return [Boolean] whether the resource is public.
      def public?
        privacy_status == 'public'
      end

      # @return [Boolean] whether the resource is private.
      def private?
        privacy_status == 'private'
      end

      # @return [Boolean] whether the resource is unlisted.
      def unlisted?
        privacy_status == 'unlisted'
      end

      # Returns the upload status of a video.
      # @return [String] if the resource is a video, the status of the
      #   uploaded video. Valid values are: deleted, failed, processed,
      #   rejected, uploading.
      # @return [nil] if the resource is not a video.
      has_attribute :upload_status

# Failure reason (Video only)

      # Returns the reason why a video failed to upload.
      # @return [String] if resource is a video with a 'failed' upload status,
      #   the reason why the video failed to upload. Valid values are: codec,
      #   conversion, emptyFile, invalidFile, tooSmall, uploadAborted.
      # @return [nil] if the resource is not a video or upload has not failed.
      has_attribute :failure_reason

      # Returns whether a video upload failed because of the codec.
      # @return [Boolean] if the resource is a video, whether the video uses
      #   a codec not supported by YouTube.
      # @return [nil] if the resource is not a video or upload has not failed.
      # @see https://support.google.com/youtube/answer/1722171
      def uses_unsupported_codec?
        failure_reason == 'codec' if video?
      end

      # Returns whether YouTube was unable to convert an uploaded video.
      # @return [Boolean] if the resource is a video, whether YouTube was
      #   unable to convert the video.
      # @return [nil] if the resource is not a video or upload has not failed.
      def has_failed_conversion?
        failure_reason == 'conversion' if video?
      end

      # Returns whether a video upload failed because the file was empty.
      # @return [Boolean] if the resource is a video, whether the video file
      #   is empty.
      # @return [nil] if the resource is not a video or upload has not failed.
      def empty?
        failure_reason == 'emptyFile' if video?
      end

      # Returns whether a video upload failed because of the file format.
      # @return [Boolean] if the resource is a video, whether the video uses
      #   a file format not supported by YouTube.
      # @return [nil] if the resource is not a video or upload has not failed.
      # @see https://support.google.com/youtube/troubleshooter/2888402?hl=en
      def invalid?
        failure_reason == 'invalidFile' if video?
      end

      # Returns whether a video upload failed because the file was too small.
      # @return [Boolean] if the resource is a video, whether the video file
      #   is too small for YouTube.
      # @return [nil] if the resource is not a video or upload has not failed.
      def too_small?
        failure_reason == 'tooSmall' if video?
      end

      # Returns whether a video upload failed because the upload was aborted.
      # @return [Boolean] if the resource is a video, whether the uploading
      #   process was aborted.
      # @return [nil] if the resource is not a video or upload has not failed.
      def aborted?
        failure_reason == 'uploadAborted' if video?
      end

# Rejection reason (Video only)

      # Returns the reason why a video was rejected by YouTube.
      # @return [String] if resource is a video with a 'rejected' upload
      #   status, the reason why the video was rejected. Valid values are:
      #   claim, copyright, duplicate, inappropriate, length, termsOfUse,
      #   trademark, uploaderAccountClosed, uploaderAccountSuspended.
      # @return [nil] if the resource is not a rejected video.
      has_attribute :rejection_reason

      # Returns whether a video was rejected because it was claimed.
      # @return [Boolean] if the resource is a rejected video, whether the
      #   video was claimed by a different account.
      # @return [nil] if the resource is not a rejected video.
      def claimed?
        rejection_reason == 'claim' if video?
      end

      # Returns whether a video was rejected because of copyright infringement.
      # @return [Boolean] if the resource is a rejected video, whether the
      #   video commits a copyright infringement.
      # @return [nil] if the resource is not a rejected video.
      def infringes_copyright?
        rejection_reason == 'copyright' if video?
      end

      # Returns whether a video was rejected because it is a duplicate.
      # @return [Boolean] if the resource is a rejected video, whether the
      #   video is a duplicate of another uploaded video.
      # @return [nil] if the resource is not a rejected video.
      def duplicate?
        rejection_reason == 'duplicate' if video?
      end

      # Returns whether a video was rejected because of inappropriate content.
      # @return [Boolean] if the resource is a rejected video, whether the
      #   video contains inappropriate content.
      # @return [nil] if the resource is not a rejected video.
      def inappropriate?
        rejection_reason == 'inappropriate' if video?
      end

      # Returns whether a video was rejected because it is too long.
      # @return [Boolean] if the resource is a rejected video, whether the
      #   video exceeds the maximum duration.
      # @return [nil] if the resource is not a rejected video.
      # @see https://support.google.com/youtube/answer/71673?hl=en
      def too_long?
        rejection_reason == 'length' if video?
      end

      # Returns whether a video was rejected because it violates terms of use.
      # @return [Boolean] if the resource is a rejected video, whether the
      #   video commits a terms of use violation.
      # @return [nil] if the resource is not a rejected video.
      def violates_terms_of_use?
        rejection_reason == 'termsOfUse' if video?
      end

      # Returns whether a video was rejected because of trademark infringement.
      # @return [Boolean] if the resource is a rejected video, whether the
      #   video commits a trademark infringement.
      # @return [nil] if the resource is not a rejected video.
      # @see https://support.google.com/youtube/answer/2801979?hl=en
      def infringes_trademark?
        rejection_reason == 'trademark' if video?
      end

      # Returns whether a video was rejected because the account was closed.
      # @return [Boolean] if the resource is a rejected video, whether the
      #   account associated with the video has been closed.
      # @return [nil] if the resource is not a rejected video.
      def belongs_to_closed_account?
        rejection_reason == 'uploaderAccountClosed' if video?
      end

      # Returns whether a video was rejected because the account was suspended.
      # @return [Boolean] if the resource is a rejected video, whether the
      #   account associated with the video has been suspended.
      # @return [nil] if the resource is not a rejected video.
      def belongs_to_suspended_account?
        rejection_reason == 'uploaderAccountSuspended' if video?
      end

# Scheduled publication (Video only)

      # Returns the date and time when a video is scheduled to be published.
      # @return [Time] if resource is a private video scheduled to be
      #   published, the date and time when the video is scheduled to publish.
      # @return [nil] if the resource is not a private video scheduled to be
      #   published.
      def scheduled_at
        publish_at if scheduled?
      end

      # Returns whether the video is scheduled to be published.
      # @return [Boolean] if the resource is a video, whether it is currently
      #   private and is scheduled to become public in the future.
      # @return [nil] if the resource is not a video.
      def scheduled?
        private? && publish_at if video?
      end

# License (Video only)

      # Returns the video’s license.
      # @return [String] if resource is a video, its license. Valid values are:
      #   creativeCommon, youtube.
      # @return [nil] if the resource is not a video.
      has_attribute :license

      # Returns whether the video uses a Creative Commons license.
      # @return [Boolean] if the resource is a video, whether it uses a
      #   Creative Commons license.
      # @return [nil] if the resource is not a video.
      # @see https://support.google.com/youtube/answer/2797468?hl=en
      def licensed_as_creative_commons?
        license == 'creativeCommon' if video?
      end

      # Returns whether the video uses the Standard YouTube license.
      # @return [Boolean] if the resource is a video, whether it uses the
      #   Standard YouTube license.
      # @return [nil] if the resource is not a video.
      # @see https://www.youtube.com/static?template=terms
      def licensed_as_standard_youtube?
        license == 'youtube' if video?
      end

# Embed (Video only)

      # Returns whether the video can be embedded on another website.
      # @return [Boolean] if the resource is a video, whether it can be
      #   embedded on another website.
      # @return [nil] if the resource is not a video.
      has_attribute :embeddable?, from: :embeddable

      # @deprecated Use {#embeddable?} instead.
      def embeddable
        embeddable?
      end

# Public stats (Video only)

      # Returns whether the video statistics are publicly viewable.
      # @return [Boolean] if the resource is a video, whether the extended
      #   video statistics on the video’s watch page are publicly viewable.
      #   By default, those statistics are viewable, and statistics like a
      #   video’s viewcount and ratings will still be publicly visible even
      #   if this property’s value is set to false.
      # @return [nil] if the resource is not a video.
      has_attribute :has_public_stats_viewable?, from: :public_stats_viewable

      # @deprecated Use {#has_public_stats_viewable?} instead.
      def public_stats_viewable
        has_public_stats_viewable?
      end

    private

      has_attribute :publish_at, type: Time

      def video?
        upload_status.present?
      end
    end
  end
end