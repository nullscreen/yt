require 'yt/models/base'

module Yt
  module Models
    # Provides methods to interact with YouTube ContentID references.
    # @see https://developers.google.com/youtube/partner/docs/v1/references
    class Reference < Base
      def initialize(options = {})
        @data = options[:data]
      end

      # @return [String] the ID that YouTube assigns and uses to uniquely
      #   identify the reference.
      def id
        @id ||= @data['id']
      end

      # @return [String] the ID that uniquely identifies the asset that the reference
      #   is associated with.
      def asset_id
        @asset_id ||= @data["assetId"]
      end

      # @return [Float] The length of the reference in seconds
      def length
        @length ||= @data["length"]
      end

      # @return [String] the ID of the source video
      # @note This field is only present if the reference was created by associating
      #   an asset with an existing YouTube video that was uploaded to a YouTube
      #   channel linked to your CMS account.
      def video_id
        @video_id ||= @data["videoId"]
      end

      # @return [String] the claim ID that represents the resulting association
      #   between the asset and the video.
      # @note This field is only present if the reference was created by associating
      #   an asset with an existing YouTube video that was uploaded to a YouTube
      #   channel linked to your CMS account.
      def claim_id
        @video_id ||= @data["videoId"]
      end

      # @return [boolean] whether or not the reference content is included in YouTube's
      #   AudioSwap program.
      # @note Set this field's value to true to indicate that the reference content
      #   should be included in YouTube's AudioSwap program.
      def audioswap_enabled
        @audioswap_enabled ||= @data["audioswapEnabled"]
      end

      # @return [boolean] should the reference be used to generate claims.
      # @note Set this value to true to indicate that the reference should not be used to 
      #   generate claims. This field is only used on AudioSwap references.
      def ignore_fp_match
        @ignore_fp_match ||= @data["ignoreFpMatch"]
      end

      # @return [Boolean] the urgent status of the reference file
      # @note Set this value to true to indicate that YouTube should prioritize 
      #   Content ID processing for a video file. YouTube processes urgent video
      #   files before other files that are not marked as urgent. This setting
      #   is primarily used for videos of live events or other videos that require
      #   time-sensitive processing. The sooner YouTube completes Content ID
      #   processing for a video, the sooner YouTube can match user-uploaded videos 
      #   to that video.
      def urgent
        @urgent ||= @data["urgent"]
      end

      # @return [String] the reference's status. Valid values are: activating, active,
      #   checking, computing_fingerprint, deleted, duplicate_on_hold, inactive, 
      #   live_streaming_processing, and urgent_reference_processing.
      def status
        @status ||= @data["status"]
      end

      # @return [Boolean] whether the reference is activating.
      def active?
        status == 'activating'
      end

      # @return [Boolean] whether the reference is active.
      def active?
        status == 'active'
      end

      # @return [Boolean] whether the reference is checking.
      def checking?
        status == 'checking'
      end

      # @return [Boolean] whether the reference is computing_fingerprint.
      def computing_fingerprint?
        status == 'computing_fingerprint'
      end

      # @return [Boolean] whether the reference is deleted.
      def deleted?
        status == 'deleted'
      end

      # @return [Boolean] whether the reference is duplicate_on_hold.
      def duplicate_on_hold?
        status == 'duplicate_on_hold'
      end

      # @return [Boolean] whether the reference is inactive.
      def inactive?
        status == 'inactive'
      end

      # @return [Boolean] whether the reference is live_streaming_processing.
      def live_streaming_processing?
        status == 'live_streaming_processing'
      end

      # @return [Boolean] whether the reference is urgent_reference_processing.
      def urgent_reference_processing?
        status == 'urgent_reference_processing'
      end

      # @return [String] An explanation of how a reference entered its current state.
      # @note  This value is only present if the reference's status is either inactive or deleted.
      def status_reason
        @status_reason ||= @data["statusReason"]
      end

      # @return [String] The ID that uniquely identifies the reference that this reference
      #   duplicates
      # @note This field is only present if the reference's status is duplicate_on_hold.
      def duplicate_leader
        @duplicate_leader ||= @data["duplicateLeader"]
      end

      # @return [String] whether the reference covers the audio, video, or
      #   audiovisual portion of the claimed content. Valid values are: audio,
      #   audiovisual, video.
      def content_type
        @content_type ||= @data["contentType"]
      end

      # @return [Boolean] whether the reference covers the audio of the content.
      def audio?
        content_type == 'audio'
      end

      # @return [Boolean] whether the reference covers the video of the content.
      def video?
        content_type == 'video'
      end

      # @return [Boolean] whether the reference covers the audiovisual of the content.
      def audiovisual?
        content_type == 'audiovisual'
      end

    end
  end
end