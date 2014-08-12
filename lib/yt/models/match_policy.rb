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

      # @note Only policyId can be currently updated, not rules.
      def update(attributes = {})
        underscore_keys! attributes
        do_update body: {policyId: attributes[:policy_id]}
        true
      end

    private

      # @return [Hash] the parameters to submit to YouTube to update an asset
      #   match policy.
      # @see https://developers.google.com/youtube/partner/docs/v1/assetMatchPolicy/update
      def update_params
        super.tap do |params|
          params[:path] = "/youtube/partner/v1/assets/#{@asset_id}/matchPolicy"
          params[:params] = {onBehalfOfContentOwner: @auth.owner_name}
          params[:expected_response] = Net::HTTPOK
        end
      end

      # If we dropped support for ActiveSupport 3, then we could simply
      # invoke transform_keys!{|key| key.to_s.underscore.to_sym}
      def underscore_keys!(hash)
        hash.dup.each_key{|key| hash[underscore key] = hash.delete key}
      end

      def underscore(value)
        value.to_s.underscore.to_sym
      end
    end
  end
end