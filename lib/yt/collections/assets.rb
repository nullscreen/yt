require 'yt/collections/base'
require 'yt/models/asset'
require 'yt/models/asset_snippet'

module Yt
  module Collections
    # Provides methods to interact with a collection of Content ID assets.
    #
    # Resources with assets are: {Yt::Models::ContentOwner content owners}.
    class Assets < Base
      def insert(attributes = {})
        params = {on_behalf_of_content_owner: @auth.owner_name}
        do_insert(params: params, body: attributes)
      end

    private

      def new_item(data)
        klass = (data["kind"] == "youtubePartner#assetSnippet") ? Yt::AssetSnippet : Yt::Asset
        klass.new attributes_for_new_item(data)
      end

      # @return [Hash] the parameters to submit to YouTube to list assets
      #   owned by the content owner.
      # @see https://developers.google.com/youtube/partner/docs/v1/assets/list
      def list_params
        super.tap do |params|
          params[:path] = assets_path
          params[:params] = assets_params
        end
      end

      def assets_params
        apply_where_params! on_behalf_of_content_owner: @auth.owner_name
      end

      # @private
      # @todo: This is one of three places outside of base.rb where @where_params
      #   is accessed; it should be replaced with a filter on params instead.
      def assets_path
        @where_params ||= {}
        if @where_params.key?(:id)
          '/youtube/partner/v1/assets'
        else
          '/youtube/partner/v1/assetSearch'
        end
      end

      # @return [Hash] the parameters to submit to YouTube to add a asset.
      # @see https://developers.google.com/youtube/partner/docs/v1/assets/insert
      def insert_params
        super.tap do |params|
          params[:path] = '/youtube/partner/v1/assets'
        end
      end
    end
  end
end
