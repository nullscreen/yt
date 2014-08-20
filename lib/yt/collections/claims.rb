require 'yt/collections/base'
require 'yt/models/claim'

module Yt
  module Collections
    # Provides methods to interact with a collection of Content ID claims.
    #
    # Resources with claims are: {Yt::Models::ContentOwner content owners}.
    class Claims < Base
      def insert(attributes = {})
        underscore_keys! attributes
        body = {  assetId: attributes[:asset_id],
                  videoId: attributes[:video_id],
                  policy: {id: attributes[:policy_id]},
                  contentType: attributes[:content_type]
        }
        params = {onBehalfOfContentOwner: @auth.owner_name}
        do_insert(params: params, body: body)
      end

    private

      def new_item(data)
        Yt::Claim.new data: data
      end

      # @return [Hash] the parameters to submit to YouTube to add a claim.
      # @see https://developers.google.com/youtube/partner/docs/v1/claims/insert
      def insert_params
        super.tap do |params|
          params[:path] = '/youtube/partner/v1/claims'
        end
      end

      # @return [Hash] the parameters to submit to YouTube to list claims
      #   administered by the content owner.
      # @see https://developers.google.com/youtube/partner/docs/v1/claims/list
      # @see https://developers.google.com/youtube/partner/docs/v1/claimSearch/list
      def list_params
        super.tap do |params|
          params[:path] = claims_path
          params[:params] = claims_params
        end
      end

      def claims_params
        apply_where_params! on_behalf_of_content_owner: @parent.owner_name
      end

      # @private
      # @todo: This is the only place outside of base.rb where @where_params
      #   is accessed; it should be replaced with a filter on params instead.
      def claims_path
        @where_params ||= {}
        if @where_params.empty? || @where_params.key?(:id)
          '/youtube/partner/v1/claims'
        else
          '/youtube/partner/v1/claimSearch'
        end
      end
    end
  end
end