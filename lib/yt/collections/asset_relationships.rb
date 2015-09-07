require 'yt/collections/base'
require 'yt/models/asset_relationship'

module Yt
  module Collections
    # Provides methods to interact with a collection of Content ID asset relationships.
    #
    # Resources with asset relationships are: {Yt::Models::ContentOwner content owners}.
    class AssetRelationships < Base
      def insert(attributes = {})
        params = {on_behalf_of_content_owner: @auth.owner_name}
        do_insert(params: params, body: attributes)
      end

    private

      # @return [Hash] the parameters to submit to YouTube to list asset relationships
      #   owned by the content owner.
      # @see https://developers.google.com/youtube/partner/docs/v1/assetRelationships/list
      def list_params
        super.tap do |params|
          params[:path] = '/youtube/partner/v1/assetRelationships'
        end
      end

      # @return [Hash] the parameters to submit to YouTube to add a asset relationship.
      # @see https://developers.google.com/youtube/partner/docs/v1/assetRelationships/insert
      def insert_params
        super.tap do |params|
          params[:path] = '/youtube/partner/v1/assetRelationships'
        end
      end
    end
  end
end
