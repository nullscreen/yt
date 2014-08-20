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
        body = {type: attributes[:type]}
        params = {on_behalf_of_content_owner: @auth.owner_name}
        do_insert(params: params, body: body)
      end

    private

      def new_item(data)
        Yt::Asset.new data: data, auth: @auth
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