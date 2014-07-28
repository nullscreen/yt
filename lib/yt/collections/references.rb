require 'yt/collections/base'
require 'yt/models/reference'

module Yt
  module Collections
    # Provides methods to interact with a collection of Content ID references.
    #
    # Resources with references are: {Yt::Models::ContentOwner content owners}.
    class References < Base

    private

      def new_item(data)
        Yt::Reference.new data: data
      end

      # @return [Hash] the parameters to submit to YouTube to list references
      #   administered by the content owner.
      # @see https://developers.google.com/youtube/partner/docs/v1/references/list
      def list_params

        super.tap do |params|
          params[:params] = references_params
          params[:path] = '/youtube/partner/v1/references'
        end
      end

      def references_params
        {onBehalfOfContentOwner: @parent.owner_name}.tap do |params|
          (@extra_params ||= {}).each do |key, value|
            params[key.to_s.camelize :lower] = value
          end
        end
      end
    end
  end
end