require 'yt/models/base'

module Yt
  module Models
    # Provides methods to interact with YouTube ContentID references.
    # @see https://developers.google.com/youtube/partner/docs/v1/references
    class Reference < Base
      def initialize(options = {})
        @data = options[:data]
        @id = options[:id]
        @auth = options[:auth]
      end

      # Soft-deletes the reference.
      #
      # @note YouTube API does not provide a +delete+ method for the Reference
      #   resource, but only an +update+ method. Updating the +status+ of a
      #   Reference to "inactive" can be considered a soft-deletion, since it
      #   allows to successively create new references for the same claim.
      # @return [Boolean] whether the reference is inactive.
      def delete
        body = {id: id, status: :inactive}
        do_update(body: body) {|data| @data = data}
        inactive?
      end

      # @return [String] the ID that YouTube assigns and uses to uniquely
      #   identify the reference.
      has_attribute :id

      # @return [String] the ID that uniquely identifies the asset that the
      #   reference is associated with.
      has_attribute :asset_id

      # @return [Float] The length of the reference in seconds
      has_attribute :length

      # @return [String] the ID of the source video. This field is only present
      #   if the reference was created by associating an asset with an existing
      #   YouTube video that was uploaded to a YouTube channel linked to your
      #   CMS account.
      has_attribute :video_id

      # @return [String] the claim ID that represents the resulting association
      #   between the asset and the video. This field is only present if the
      #   reference was created by associating an asset with an existing
      #   YouTube video that was uploaded to a YouTube channel linked to your
      #   CMS account.
      has_attribute :claim_id

      # @return [boolean] whether or not the reference content is included in
      #   YouTube's AudioSwap program. Set this field's value to true to
      #   indicate that  the reference content should be included in YouTube's
      #   AudioSwap program.
      has_attribute :audioswap_enabled?, from: :audioswap_enabled

      # @return [boolean] should the reference be used to generate claims. Set
      #   this value to true to indicate that the reference should not be used
      #   to generate claims. This field is only used on AudioSwap references.
      has_attribute :ignore_fp_match?, from: :ignore_fp_match

      # @return [Boolean] the urgent status of the reference file.
      #   Set this value to true to indicate that YouTube should prioritize
      #   Content ID processing for a video file. YouTube processes urgent
      #   video files before other files that are not marked as urgent.
      #   This setting is primarily used for videos of live events or other
      #   videos that require time-sensitive processing.
      #   The sooner YouTube completes Content ID processing for a video, the
      #   sooner YouTube can match user-uploaded videos to that video.
      has_attribute :urgent?, from: :urgent

      # @return [String] An explanation of how a reference entered its current
      #   state. This value is only present if the reference’s status is either
      #   inactive or deleted.
      has_attribute :status_reason

      # @return [String] The ID that uniquely identifies the reference that
      #   this reference duplicates. This field is only present if the
      #   reference’s status is duplicate_on_hold.
      has_attribute :duplicate_leader

# Status

      # @return [String] the reference’s status. Possible values are:
      #   +'activating'+, +'active'+, +'checking'+, +'computing_fingerprint'+,
      #   +'deleted'+, +'duplicate_on_hold'+, +'inactive'+,
      #   +'live_streaming_processing'+, +'urgent_reference_processing'+.
      has_attribute :status

      # @return [Boolean] whether the reference is pending.
      def activating?
        status == 'activating'
      end

      # @return [Boolean] whether the reference is active.
      def active?
        status == 'active'
      end

      # @return [Boolean] whether the reference is being compared to existing
      #   references to identify any reference conflicts that might exist.
      def checking?
        status == 'checking'
      end

      # @return [Boolean] whether the reference’s fingerprint is being
      #   computed.
      def computing_fingerprint?
        status == 'computing_fingerprint'
      end

      # @return [Boolean] whether the reference is deleted.
      def deleted?
        status == 'deleted'
      end

      # @return [Boolean] whether the reference iis a duplicate and is on hold.
      def duplicate_on_hold?
        status == 'duplicate_on_hold'
      end

      # @return [Boolean] whether the reference is inactive.
      def inactive?
        status == 'inactive'
      end

      # @return [Boolean] whether the reference is being processed from a live
      #   video stream.
      def live_streaming_processing?
        status == 'live_streaming_processing'
      end

      # @return [Boolean] whether the reference is urgent_reference_processing.
      def urgent_reference_processing?
        status == 'urgent_reference_processing'
      end

# Content Type

      # Returns the audiovisual portion of the referenced content.
      # @return [String] the audiovisual portion of the referenced content.
      #   Possible values are: +'audio'+, +'audiovisual'+, +'video'+.
      has_attribute :content_type

      # @return [Boolean] whether the reference covers only the audio.
      def audio?
        content_type == 'audio'
      end

      # @return [Boolean] whether the reference covers only the video.
      def video?
        content_type == 'video'
      end

      # @return [Boolean] whether the reference covers both audio and video.
      def audiovisual?
        content_type == 'audiovisual'
      end

    private

      # @see https://developers.google.com/youtube/partner/docs/v1/references/update
      def update_params
        super.tap do |params|
          params[:expected_response] = Net::HTTPOK
          params[:path] = "/youtube/partner/v1/references/#{id}"
          params[:params] = {on_behalf_of_content_owner: @auth.owner_name}
        end
      end
    end
  end
end
