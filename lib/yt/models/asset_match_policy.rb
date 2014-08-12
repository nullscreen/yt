require 'yt/models/base'

module Yt
  module Models
    # Provides methods to interact with YouTube ContentID asset match
    # policies which YouTube applies to user-uploaded videos that match
    # the asset.
    # @see https://developers.google.com/youtube/partner/docs/v1/assetMatchPolicy
    class AssetMatchPolicy < Resource
      def initialize(options = {})
        @data = options[:data]
        @asset_id = options[:asset_id]
        @auth = options[:auth]
      end

      def update(attributes = {})
        camelize_keys! attributes

        do_update params: {onBehalfOfContentOwner: @auth.owner_name}, body: attributes do |data|
          @data = data
          @policy_id = nil
          @rules = nil
          true
        end
      end

      # @return [String] A value that uniquely identifies the Asset
      #   resource which contains this match policy
      def asset_id
        @asset_id
      end

      # @return [String] A value that uniquely identifies the Policy
      #   resource that YouTube applies to user-uploaded videos that
      #   match the asset.
      def policy_id
        @policy_id ||= @data['policyId']
      end

      # @return [Array<PolicyRule>] A list of rules that collectively
      #   define the policy that the content owner wants to apply to
      #   user-uploaded videos that match the asset. Each rule specifies
      #   the action that YouTube should take and may optionally specify
      #   the conditions under which that action is enforced.
      def rules
        @rules ||= @data.fetch('rules', []).map{|rule| PolicyRule.new data: rule}
      end

      private

      def update_params
        super.tap do |params|
          params[:path] = "/youtube/partner/v1/assets/#{asset_id}/matchPolicy"
        end
      end

      def camelize_keys!(hash = {})
        hash.dup.each_key do |key|
          hash[key.to_s.camelize(:lower).to_sym] = hash.delete key
        end
      end

    end
  end
end