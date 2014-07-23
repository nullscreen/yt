require 'yt/models/account'

module Yt
  module Models
    # Provides methods to interact with YouTube CMS accounts.
    # @see https://cms.youtube.com
    # @see https://developers.google.com/youtube/analytics/v1/content_owner_reports
    class ContentOwner < Account

      # @!attribute [r] partnered_channels
      #   @return [Yt::Collection::PartneredChannels] the channels managed by the CMS account.
      has_many :partnered_channels

      # @!attribute [r] claims
      #   @return [Yt::Collection::Claims] the claims administered by the content owner.
      has_many :claims

      def initialize(options = {})
        super options
        @owner_name = options[:owner_name]
      end
    end
  end
end