require 'yt/models/base'

module Yt
  module Models
    # Provides methods to interact with YouTube ContentID asset ownership,
    # which provide ownership information for the specified asset.
    # @see https://developers.google.com/youtube/partner/docs/v1/ownership
    class Ownership < Base
      def initialize(options = {})
        @asset_id = options[:asset_id]
        @auth = options[:auth]
      end

      # update the ownership details
      def update(attributes = {})
        underscore_keys! attributes
        do_update body: {   kind: attributes[:policy_id],
                            general: attributes[:general]
        }
        true
      end

    private

      # @return [Hash] the parameters to submit to YouTube to update an asset
      #  ownership.
      # @see https://developers.google.com/youtube/partner/docs/v1/ownership/update
      def update_params
        super.tap do |params|
          params[:path] = "/youtube/partner/v1/assets/#{@asset_id}/ownership"
          params[:params] = {onBehalfOfContentOwner: @auth.owner_name}
          params[:expected_response] = Net::HTTPOK
        end
      end

    end
  end
end