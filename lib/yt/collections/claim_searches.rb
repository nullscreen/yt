require 'yt/models/claim'

module Yt
  module Collections
    class ClaimSearches < Base

    private

      def new_item(data)
        Yt::Claim.new data: data
      end

      # @return [Hash] the parameters to submit to YouTube to list claims that match the search criteria.
      # @see https://developers.google.com/youtube/partner/docs/v1/claimSearch/list
      def list_params
        super.tap do |params|
          params[:path] = "/youtube/partner/v1/claimSearch"
          params[:params] = {onBehalfOfContentOwner: @parent.owner_name}.merge(@extra_params || {})
        end
      end
      
    end
  end
end
