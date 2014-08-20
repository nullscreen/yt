require 'yt/collections/resources'
require 'yt/models/ownership'

module Yt
  module Collections
    # Provides methods to interact with a the ownership of a YouTube resource.
    #
    # Resources with ownerships are: {Yt::Models::Asset assets}.
    class Ownerships < Resources

    private

      def new_item(data)
        Yt::Ownership.new data: data, asset_id: @parent.id, auth: @auth
      end

      # @return [Hash] the parameters to submit to YouTube to get ownerships.
      # @see https://developers.google.com/youtube/partner/docs/v1/ownership/get
      def list_params
        super.tap do |params|
          params[:path] = "/youtube/partner/v1/assets/#{@parent.id}/ownership"
          params[:params] = {onBehalfOfContentOwner: @auth.owner_name}
        end
      end

      # @private
      # @note Ownerships overwrites +fetch_page+ since it’s a get.
      def fetch_page(params = {})
        response = request(params).run
        {items: [response.body], token: nil}
      end
    end
  end
end