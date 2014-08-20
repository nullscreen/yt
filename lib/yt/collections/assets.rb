require 'yt/collections/base'
require 'yt/models/asset'

module Yt
  module Collections
    # Provides methods to interact with a collection of Content ID assets.
    #
    # Resources with assets are: {Yt::Models::ContentOwner content owners}.
    class Assets < Base
      def insert(attributes = {})
        underscore_keys! attributes
        body = {  type: attributes[:type], 
                  metadata: attributes[:metadata]
        }
        params = {onBehalfOfContentOwner: @auth.owner_name}
        do_insert(params: params, body: body)
      end

    private

      def new_item(data)
        Yt::Asset.new data: data
      end

      # @return [Hash] the parameters to submit to YouTube to add an asset.
      # @see https://developers.google.com/youtube/partner/docs/v1/references/insert
      def insert_params
        super.tap do |params|
          params[:path] = '/youtube/partner/v1/assets'
        end
      end

      # @return [Hash] the parameters to submit to YouTube to list assets
      #   administered by the content owner.
      # @see https://developers.google.com/youtube/partner/docs/v1/assets/list
      # @see https://developers.google.com/youtube/partner/docs/v1/assetSearch/list
      def list_params
        super.tap do |params|
          params[:path] = assets_path
          params[:params] = assets_params
        end
      end

      def assets_params
        apply_where_params! on_behalf_of_content_owner: @parent.owner_name
      end

      # @private
      # @todo: This is the only place outside of base.rb where @where_params
      #   is accessed; it should be replaced with a filter on params instead.
      def assets_path
        @where_params ||= {}
        if @where_params.key?(:id)
          '/youtube/partner/v1/assets'
        else
          '/youtube/partner/v1/assetSearch'
        end
      end
    end
  end
end