require 'yt/models/timestamp'

module Yt
  module Models
    # @private
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

      has_attribute :privacy_status
      has_attribute :upload_status
      has_attribute :failure_reason
      has_attribute :rejection_reason
      has_attribute :license
      has_attribute :embeddable
      has_attribute :public_stats_viewable
      has_attribute :publish_at, type: Time
    end
  end
end