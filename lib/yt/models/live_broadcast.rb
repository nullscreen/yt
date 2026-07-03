require 'yt/models/base'

module Yt
  module Models
    # Provides methods to interact with YouTube Content ID live broadcasts.
    # @see https://developers.google.com/youtube/v3/live/docs/liveBroadcasts
    class LiveBroadcast < Resource

      ### SNIPPET ###

      # @!attribute [r] title
      #   @return [String] the broadcast’s title.
      delegate :title, to: :snippet

      # @!attribute [r] description
      #   @return [String] the broadcast’s description.
      delegate :description, to: :snippet

      # @!attribute [r] scheduledStartTime
      #   @return [Time] the broadcast’s scheduled start time.
      delegate :scheduled_start_time, to: :snippet

      # @!attribute [r] scheduledEndTime
      #   @return [Time] the broadcast’s scheduled end time.
      delegate :scheduled_end_time, to: :snippet

      # @!attribute [r] published_at
      #   @return [Time] the date and time that the broadcast was published.
      delegate :published_at, to: :snippet

      # @return [String] the ID that YouTube assigns and uses to uniquely
      #   identify the live_broadcast.
      has_attribute :id

      ### PRIVATE API ###

      # @see https://developers.google.com/youtube/v3/docs/liveBroadcasts/update
      def update_parts
        snippet_keys = [:title, :description, :scheduled_start_time, :scheduled_end_time]
        snippet = {keys: snippet_keys, sanitize_brackets: true}
        status_keys = [:privacy_status, :recording_status,
                       :publish_at, :self_declared_made_for_kids]
        {snippet: snippet, status: {keys: status_keys}}
      end

      ### ACTIONS (UPLOAD, UPDATE, DELETE) ###

      # Deletes the live broadcast.
      # @return [Boolean] whether the live broadcast does not exist anymore.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} is not an
      #   authenticated Yt::Account with permissions to delete the live broadcast.
      def delete(options = {})
        do_delete {@id = nil}
        !exists?
      end

      # Updates the attributes of a broadcast.
      # @return [Boolean] whether the broadcast was successfully updated.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} is not an
      #   authenticated Yt::Account with permissions to update the broadcast.
      # @param [Hash] attributes the attributes to update.
      # @option attributes [String] :title The new broadcast’s title.
      #   Cannot have more than 100 characters. Can include the characters
      #   < and >, which are replaced to ‹ › in order to be accepted by YouTube.
      # @option attributes [String] :description The new broadcast’s description.
      #   Cannot have more than 5000 bytes. Can include the characters
      #   < and >, which are replaced to ‹ › in order to be accepted by YouTube.
      # @option attributes [String] :privacy_status The new broadcast’s privacy
      #   status. Must be one of: private, unscheduled, public.
      # @example Update title and description of a broadcast.
      #   broadcast.update title: 'New title', description: 'New description'
      # @example Update status of a broadcast.
      #   broadcast.update privacy_status: 'public'
      def update(attributes = {})
        super
      end

      # @private
      def exists?
        !@id.nil?
      end
    end
  end
end
