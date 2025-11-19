require 'yt/models/base'

module Yt
  module Models
    # @private
    # Encapsulates branding settings about the resource, such as trailer on channel
    # @see https://developers.google.com/youtube/v3/docs/channels#resource-representation
    class BrandingSetting < Base
      attr_reader :data

      def initialize(options = {})
        @data = options[:data]
      end

      has_attribute :channel, default: {}

      def unsubscribed_trailer
        channel['unsubscribedTrailer']
      end

      has_attribute :image, default: {}

      def banner_external_url
        image['bannerExternalUrl']
      end
    end
  end
end

