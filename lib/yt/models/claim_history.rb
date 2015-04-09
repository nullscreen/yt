require 'yt/models/base'
require 'yt/models/claim_event'

module Yt
  module Models
    # Provides methods to interact with YouTube ContentID claims.
    # @see https://developers.google.com/youtube/partner/docs/v1/claims
    class ClaimHistory < Base
      def initialize(options = {})
        @data = options[:data]
        @id = options[:id]
        @auth = options[:auth]
      end

      # @return [String] the ID that YouTube assigns and uses to uniquely
      #   identify the claim.
      has_attribute :id

      # @return [String] the unique YouTube channel ID of the channel to
      #   which the claimed video was uploaded.
      has_attribute :uploader_channel_id

      # @return [Array<String>] the list of events associated with the claim.
      has_attribute :events, from: :event do |event_info|
        event_info.map{|event| ClaimEvent.new data: event}
      end
    end
  end
end