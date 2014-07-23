require 'yt/collections/base'
require 'yt/models/claim'

module Yt
  module Collections
    # Provides methods to interact with a collection of Content ID claims.
    #
    # Resources with claims are: {Yt::Models::ContentOwner content owners}.
    class Claims < Base

    private

      def new_item(data)
        Yt::Claim.new data: data
      end

      # @return [Hash] the parameters to submit to YouTube to list claims
      #   administered by the content owner.
      # @see https://developers.google.com/youtube/partner/docs/v1/claims/list
      # @see https://developers.google.com/youtube/partner/docs/v1/claimSearch/list
      def list_params

        super.tap do |params|
          params[:params] = claims_params
          params[:path] = claims_path
        end
      end

      def claims_params
        {onBehalfOfContentOwner: @parent.owner_name}.tap do |params|
          (@extra_params ||= {}).each do |key, value|
            params[key.to_s.camelize :lower] = value
          end
        end
      end

      def claims_path
        if @extra_params.empty? || @extra_params.key?(:id)
          '/youtube/partner/v1/claims'
        else
          '/youtube/partner/v1/claimSearch'
        end
      end
    end
  end
end