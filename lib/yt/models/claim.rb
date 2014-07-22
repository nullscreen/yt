require 'yt/models/base'

module Yt
  module Models
    class Claim < Base
      def initialize(options = {})
        @data = options[:data]
      end

      def id
        @data["id"]
      end

      def asset_id
        @data["assetId"]
      end

      def video_id
        @data["videoId"]
      end

      def status
        @data["status"]
      end

      def policy
        @data["policy"]
      end

      def content_type
        @data["contentType"]
      end

      def time_created
        @data["timeCreated"]
      end

      def block_outside_ownership
        @data["blockOutsideOwnership"]
      end

      def origin
        @data["origin"]
      end

      def video_views
        @data["videoViews"]
      end

      def video_title
        @data["videoTitle"]
      end

    end
  end
end