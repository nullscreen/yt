require 'yt/collections/resources'
require 'yt/models/claim'

module Yt
  module Collections
    # Provides methods to interact with a the claim history options of a YouTube claim.
    #
    # Resources with claim history are: {Yt::Models::Claim claims}.
    class ClaimHistories < Resources

    private

      def attributes_for_new_item(data)
        {data: data, id: @parent.id, auth: @auth}
      end

      # @return [Hash] the parameters to submit to YouTube to get claim history.
      # @see https://developers.google.com/youtube/partner/docs/v1/claimHistory/get
      def list_params
        super.tap do |params|
          params[:path] = "/youtube/partner/v1/claimHistory/#{@parent.id}"
          params[:params] = {on_behalf_of_content_owner: @auth.owner_name}
        end
      end

      # @private
      # @note ClaimHistories overwrites +fetch_page+ since it’s a get.
      def fetch_page(params = {})
        response = list_request(params).run
        {items: [response.body], token: nil}
      end
    end
  end
end
