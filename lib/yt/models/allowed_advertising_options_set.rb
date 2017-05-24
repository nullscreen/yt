require 'yt/models/base'

module Yt
  module Models
    # This object identifies the ad formats that the content owner is allowed to use
    # @see https://developers.google.com/youtube/partner/docs/v1/contentOwnerAdvertisingOptions
    class AllowedAdvertisingOptionsSet < Base
      def initialize(options = {})
        @data = options[:data]
      end

      # This setting indicates whether the partner can display ads when videos
      # run in an embedded player.
      # @return [Boolean]
      has_attribute :ads_on_embeds

      # This setting indicates whether the partner can enable automatically
      # generated breaks on videos longer than 10 minutes.
      # @return [Boolean]
      has_attribute :auto_generated_breaks

      # @return [Array<String>] A list of ad formats that the partner is allowed to use for claimed, user-uploaded content.
      has_attribute :ugc_ad_formats, default: []

      # @return [Array<String>] A list of ad formats that the partner is allowed to use for its uploaded videos.
      has_attribute :lic_ad_formats, default: []
    end
  end
end
