require 'yt/models/base'
require 'yt/models/right_owner'

module Yt
  module Models
    # Provides methods to interact with YouTube ContentID asset ownership,
    # which provide ownership information for the specified asset.
    # @see https://developers.google.com/youtube/partner/docs/v1/ownership
    class Ownership < Base
      def initialize(options = {})
        @data = options[:data] || {}
        @auth = options[:auth]
        @asset_id = options[:asset_id]
      end

      def update(attributes = {})
        underscore_keys! attributes
        do_update body: attributes
        true
      end

      # Assigns 100% of the general ownership of the asset to @auth.
      def obtain!
        update general: [{ratio: 100, owner: @auth.owner_name, type: :exclude}]
      end

      # Releases 100% of the general ownership of the asset from @auth.
      def release!
        update general: [{ratio: 0, owner: @auth.owner_name, type: :exclude}]
      end

      # @return [Array<RightOwner>] a list that identifies the owners of an
      #   asset and the territories where each owner has ownership.
      #   General  asset ownership is used for all types of assets and is the
      #   only type  of ownership data that can be provided for assets that are
      #   not compositions.
      has_attribute :general_owners, from: :general do |data|
        as_owners data
      end

      # @return [Array<RightOwner>] a list that identifies owners of the
      #   performance rights for a composition asset.
      has_attribute :performance_owners, from: :performance do |data|
        as_owners data
      end

      # @return [Array<RightOwner>] a list that identifies owners of the
      #   synchronization rights for a composition asset.
      has_attribute :synchronization_owners, from: :synchronization do |data|
        as_owners data
      end

      # @return [Array<RightOwner>] a list that identifies owners of the
      #   mechanical rights for a composition asset.
      has_attribute :mechanical_owners, from: :mechanical do |data|
        as_owners data
      end

    private

      # @see https://developers.google.com/youtube/partner/docs/v1/ownership/update
      def update_params
        super.tap do |params|
          params[:expected_response] = Net::HTTPOK
          params[:path] = "/youtube/partner/v1/assets/#{@asset_id}/ownership"
          params[:params] = {on_behalf_of_content_owner: @auth.owner_name}
        end
      end

      def as_owners(data)
        (data || []).map{|owner_data| Yt::RightOwner.new data: owner_data}
      end
    end
  end
end