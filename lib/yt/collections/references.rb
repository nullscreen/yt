require 'yt/collections/base'
require 'yt/models/reference'

module Yt
  module Collections
    # Provides methods to interact with a collection of Content ID references.
    #
    # Resources with references are: {Yt::Models::ContentOwner content owners}.
    class References < Base
      def insert(attributes = {})
        underscore_keys! attributes
        body = {contentType: attributes[:content_type] }
        params = {claim_id: attributes[:claim_id], on_behalf_of_content_owner: @auth.owner_name}
        do_insert(params: params, body: body)
      end

    private

      def new_item(data)
        Yt::Reference.new data: data, auth: @auth
      end

      # @return [Hash] the parameters to submit to YouTube to add a reference.
      # @see https://developers.google.com/youtube/partner/docs/v1/references/insert
      def insert_params
        super.tap do |params|
          params[:path] = '/youtube/partner/v1/references'
        end
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