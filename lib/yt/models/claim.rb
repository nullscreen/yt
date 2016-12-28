require 'yt/models/base'

module Yt
  module Models
    # Provides methods to interact with YouTube ContentID claims.
    # @see https://developers.google.com/youtube/partner/docs/v1/claims
    class Claim < Base
      attr_reader :auth, :data

      def initialize(options = {})
        @data = options[:data]
        @id = options[:id]
        @auth = options[:auth]
        @asset = options[:asset] if options[:asset]
      end

      # @!attribute [r] claim_history
      #   @return [Yt::Collections::ClaimHistories] the claim's history.
      has_one :claim_history

      # Soft-deletes the claim.
      # @note YouTube API does not provide a +delete+ method for the Asset
      #   resource, but only an +update+ method. Updating the +status+ of a
      #   Asset to "inactive" can be considered a soft-deletion.
      # @return [Boolean] whether the claim is inactive.
      def delete
        body = {status: :inactive}
        do_patch(body: body) {|data| @data = data}
        inactive?
      end

      # @return [String] the ID that YouTube assigns and uses to uniquely
      #   identify the claim.
      has_attribute :id

      # @return [String] the unique YouTube asset ID that identifies the asset
      #   associated with the claim.
      has_attribute :asset_id

      # @return [String] the unique YouTube video ID that identifies the video
      #   associated with the claim.
      has_attribute :video_id

# Status

      # Returns the claim’s status.
      # @return [String] the claim’s status. Possible values are: +'active'+,
      #   +'appealed'+, +'disputed'+, +'inactive'+, +'pending'+, +'potential'+,
      #   +'takedown'+, +'unknown'+.
      # @note When updating a claim, you can update its status from active to
      #   inactive to effectively release the claim, but the API does not
      #   support other updates to a claim’s status.
      has_attribute :status

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

# Content Type

      # Returns the audiovisual portion of the claimed content.
      # @return [String] the audiovisual portion of the claimed content.
      #   Possible values are: +'audio'+, +'audiovisual'+, +'video'+.
      has_attribute :content_type

      # @return [Boolean] whether the claim covers only the audio.
      def audio?
        content_type == 'audio'
      end

      # @return [Boolean] whether the claim covers only the video.
      def video?
        content_type == 'video'
      end

      # @return [Boolean] whether the claim covers both audio and video.
      def audiovisual?
        content_type == 'audiovisual'
      end

      # @return [String] the source of the claim
      def source
        @data.fetch('origin', {})['source']
      end

      # @return [Yt::Models::Asset] the asset of the claim
      def asset
        @asset
      end

      # @return [Time] the date and time that the claim was created.
      has_attribute :created_at, type: Time, from: :time_created

      # @return [Boolean] whether a third party created the claim.
      has_attribute :third_party?, from: :third_party_claim do |value|
        value == true
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
      has_attribute :block_outside_ownership?, from: :block_outside_ownership

      # @return [String] The unique ID that YouTube uses to identify the
      #   reference that generated the match.
      has_attribute :match_reference_id, from: :match_info do |match_info|
        (match_info || {})['referenceId']
      end


    private

      # @see https://developers.google.com/youtube/partner/docs/v1/claims/update
      def patch_params
        super.tap do |params|
          params[:expected_response] = Net::HTTPOK
          params[:path] = "/youtube/partner/v1/claims/#{id}"
          params[:params] = {on_behalf_of_content_owner: @auth.owner_name}
        end
      end
    end
  end
end
