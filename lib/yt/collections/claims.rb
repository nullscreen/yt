require 'yt/models/claim'

module Yt
  module Collections
    class Claims < Base

    private

      def new_item(data)
        Yt::Claim.new data: data
      end

      # @return [Hash] the parameters to submit to YouTube to list claims administered by the content owner.
      # @see https://developers.google.com/youtube/partner/docs/v1/claims/list
      def list_params
        super.tap do |params|
          params[:path] = "/youtube/partner/v1/claims"
          params[:params] = {onBehalfOfContentOwner: @parent.owner_name}.merge(@extra_params || {})
        end
      end
      
    end
  end
end
