require 'yt/collections/base'
require 'yt/models/policy'

module Yt
  module Collections
    # Provides methods to interact with a collection of Content ID policies.
    #
    # Resources with policies are: {Yt::Models::ContentOwner content owners}.
    class Policies < Base

    private

      # @return [Hash] the parameters to submit to YouTube to list policies
      #   saved by the content owner.
      # @see https://developers.google.com/youtube/partner/docs/v1/policies/list
      def list_params
        super.tap do |params|
          params[:params] = policies_params
          params[:path] = '/youtube/partner/v1/policies'
        end
      end

      def policies_params
        apply_where_params! on_behalf_of_content_owner: @parent.owner_name
      end
    end
  end
end