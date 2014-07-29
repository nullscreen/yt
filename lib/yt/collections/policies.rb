require 'yt/collections/base'
require 'yt/models/policy'

module Yt
  module Collections
    # Provides methods to interact with a collection of Content ID policies.
    #
    # Resources with policies are: {Yt::Models::ContentOwner content owners}.
    class Policies < Base

    private

      def new_item(data)
        Yt::Policy.new data: data
      end

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
        {onBehalfOfContentOwner: @parent.owner_name}.tap do |params|
          (@extra_params ||= {}).each do |key, value|
            params[key.to_s.camelize :lower] = value
          end
        end
      end
    end
  end
end