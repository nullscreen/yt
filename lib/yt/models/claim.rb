require 'yt/models/base'

module Yt
  module Models
    # Provides methods to interact with YouTube ContentID claims.
    # @see https://developers.google.com/youtube/partner/docs/v1/claims
    class Claim < Base
      def initialize(options = {})
        @data = options[:data]
      end

      # @return [String] the ID that YouTube assigns and uses to uniquely
      #   identify the claim.
      def id
        @id ||= @data['id']
      end

      # @return [String] the unique YouTube asset ID that identifies the asset
      #   associated with the claim.
      def asset_id
        @asset_id ||= @data["assetId"]
      end

      # @return [String] the unique YouTube video ID that identifies the video
      #   associated with the claim.
      def video_id
        @video_id ||= @data["videoId"]
      end

      # @return [String] the claim’s status. Valid values are: active,
      #   appealed, disputed, inactive, pending, potential, takedown, unknown.
      # @note When updating a claim, you can update its status from active to
      #   inactive to effectively release the claim, but the API does not
      #   support other updates to a claim’s status.
      def status
        @status ||= @data["status"]
      end

      # @return [Boolean] whether the claim is active.
      def active?
        status == 'active'
      end

      # @return [Boolean] whether the claim is appealed.
      def appealed?
        status == 'appealed'
      end

      # @return [Boolean] whether the claim is disputed.
      def disputed?
        status == 'disputed'
      end

      # @return [Boolean] whether the claim is inactive.
      def inactive?
        status == 'inactive'
      end

      # @return [Boolean] whether the claim is pending.
      def pending?
        status == 'pending'
      end

      # @return [Boolean] whether the claim is potential.
      def potential?
        status == 'potential'
      end

      # @return [Boolean] whether the claim is takedown.
      def takedown?
        status == 'takedown'
      end

      # @return [Boolean] whether the claim status is unknown.
      def has_unknown_status?
        status == 'unknown'
      end

      # @return [String] whether the claim covers the audio, video, or
      #   audiovisual portion of the claimed content. Valid values are: audio,
      #   audiovisual, video.
      def content_type
        @content_type ||= @data["contentType"]
      end

      # @return [Boolean] whether the covers the audio of the content.
      def audio?
        content_type == 'audio'
      end

      # @return [Boolean] whether the covers the video of the content.
      def video?
        content_type == 'video'
      end

      # @return [Boolean] whether the covers the audiovisual of the content.
      def audiovisual?
        content_type == 'audiovisual'
      end

      # @return [Time] the date and time that the claim was created.
      def created_at
        @created_at ||= Time.parse @data["timeCreated"]
      end

      # Return whether the video should be blocked where not explicitly owned.
      # @return [Boolean] whether the claimed video should be blocked anywhere
      #   it is not explicitly owned. For example, if you upload a video for an
      #   asset that you own in the United States and Canada, and you claim the
      #   video with a usage policy to monetize the video everywhere. Since the
      #   policy is only applied in countries where you own the asset, YouTube
      #   will actually monetize the video in the United States and Canada.
      #   By default, the video will still be viewable in other countries even
      #   though it will not be monetized in those countries. However, if you
      #   set this property to true, then the video will be monetized in the
      #   United States and Canada and blocked in all other countries.
      def block_outside_ownership?
        @block_outside_ownership ||= @data["blockOutsideOwnership"]
      end
    end
  end
end