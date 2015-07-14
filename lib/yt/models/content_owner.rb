require 'yt/models/account'

module Yt
  module Models
    # Provides methods to interact with YouTube CMS accounts.
    # @see https://cms.youtube.com
    # @see https://developers.google.com/youtube/analytics/v1/content_owner_reports
    class ContentOwner < Account

      #   @return [Yt::Collections::ContentOwnerAdvertisingOptionsSets] the advertising options of the ContentOwner
      has_one :content_owner_advertising_options_set

      # @!attribute [r] partnered_channels
      #   @return [Yt::Collections::PartneredChannels] the channels managed by the CMS account.
      has_many :partnered_channels

      # @!attribute [r] claims
      #   @return [Yt::Collections::Claims] the claims administered by the content owner.
      has_many :claims

      # @!attribute [r] assets
      #   @return [Yt::Collection::Assets] the assets administered by the content owner.
      has_many :assets

      # @!attribute [r] references
      #   @return [Yt::Collections::References] the references administered by the content owner.
      has_many :references

      # @!attribute [r] policies
      #   @return [Yt::Collections::Policies] the policies saved by the content owner.
      has_many :policies

      def initialize(options = {})
        super options
        @owner_name = options[:owner_name]
      end

      def create_reference(params = {})
        references.insert params
      end

      def create_asset(params = {})
        assets.insert params
      end

      def create_claim(params = {})
        claims.insert params
      end
    end
  end
end
