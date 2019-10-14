require 'yt/models/base'

module Yt
  module Models
    # Provides methods to interact with YouTube ContentID asset match policies,
    # which YouTube applies to user-uploaded videos that match the asset.
    # @see https://developers.google.com/youtube/partner/docs/v1/assetMatchPolicy
    class MatchPolicy < Base
      def initialize(options = {})
        @asset_id = options[:asset_id]
        @auth = options[:auth]
      end

      def update(attributes = {})
        underscore_keys! attributes
        do_update body: attributes.slice(:policy_id)
        true
      end

    private

      # @see https://developers.google.com/youtube/partner/docs/v1/assetMatchPolicy/update
      def update_params
        super.tap do |params|
          params[:path] = "/youtube/partner/v1/assets/#{@asset_id}/matchPolicy"
          params[:params] = {on_behalf_of_content_owner: @auth.owner_name}
          params[:expected_response] = Net::HTTPOK
        end
      end
    end
  end
end
