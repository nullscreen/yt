require 'yt/collections/base'
require 'yt/models/asset'

module Yt
  module Collections
    # Provides methods to interact with a collection of Content ID assets.
    #
    # Resources with assets are: {Yt::Models::ContentOwner content owners}.
    class Assets < Base

    private

      def new_item(data)
        Yt::Asset.new data: data, auth: @auth
      end

      # @return [Hash] the parameters to submit to YouTube to list assets
      #   owned by the content owner.
      # @see https://developers.google.com/youtube/partner/docs/v1/assets/list
      def list_params
        super.tap do |params|
          params[:params] = assets_params
          params[:path] = '/youtube/partner/v1/assets'
        end
      end

      def assets_params
        apply_where_params! on_behalf_of_content_owner: @parent.owner_name
      end
    end
  end
end