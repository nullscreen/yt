require 'yt/models/base'

module Yt
  module Models
    class ClaimEvent < Base
      def initialize(options = {})
        @data = options[:data]
      end

      REASONS = %w(asset_transfer_request audio_muted audio_replaced audioswap_removed
        channel_transferred channel_whitelisted closed_audio_claim_on_visual_reference
        closed_audio_revshare closed_by_admin closed_cover_revshare
        closed_invalid_reference_segment closed_manually closed_partner_exclusion
        closed_private_video closed_reference_conflict copyrighted_content_matched
        counter_received dispute_resolution duplicate invalid_claim muting_audio
        ownership_removed partner_deactivated pending_activation pending_adsense
        pending_fingerprint pending_for_review reference_removed released replaced
        review_expired revshare_disabled risk_of_error song_erased
        suspended_monetization_on_channel video_classifier_rejecion video_content_modified
        video_removed video_taken_down)

      # @return [Time] the date and time when the event occurred.
      has_attribute :time, type: Time

      # @return [String] the reason an event occurred.
      has_attribute :reason

      # @return [String] the event's type.
      has_attribute :type

      # @return [String] the source type which triggered the event.
      has_attribute :source_type, from: :source do |source|
        (source || {})['type']
      end

      # @return [String] the ID of the content owner that initiated
      #   the event.
      has_attribute :source_content_owner_id, from: :source do |source|
        (source || {})['contentOwnerId']
      end

      # @return [String] the email address of the user who initiated
      #   the event.
      has_attribute :source_user_email, from: :source do |source|
        (source || {})['userEmail']
      end

      # @return [String] the reason that explains why a
      #   dispute_create event occurred.
      has_attribute :dispute_reason, from: :type_details do |type_details|
        (type_details || {})['disputeReason']
      end

      # @return [String] a free-text explanation of the reason that a claim
      #   was disputed. This property is returned for dispute_create events.
      has_attribute :dispute_notes, from: :type_details do |type_details|
        (type_details || {})['disputeNotes']
      end

      # @return [String] the event status that resulted from a claim_update
      #   event.
      has_attribute :update_status, from: :type_details do |type_details|
        (type_details || {})['updateStatus']
      end
    end
  end
end