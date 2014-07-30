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
        apply_where_params! on_behalf_of_content_owner: @parent.owner_name
      end
    end
  end
end