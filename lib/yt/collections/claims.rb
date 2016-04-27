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
        body = attributes.slice :asset_id, :video_id, :content_type, :policy
        body[:policy] = {id: attributes[:policy_id]} if attributes[:policy_id]
        params = attributes.slice(:is_manual_claim).merge({on_behalf_of_content_owner: @auth.owner_name})
        do_insert(params: params, body: body)
      end

    private

      def attributes_for_new_item(data)
        {}.tap do |attributes|
          attributes[:id] = data['id']
          attributes[:auth] = @auth
          attributes[:data] = data
          attributes[:asset] = data['asset']
        end
      end

      def eager_load_items_from(items)
        if included_relationships.include? :asset
          asset_ids = items.map{|a| a.values_at 'videoId', 'assetId'}.to_h.values
          conditions = { id: asset_ids.join(','), fetch_metadata: 'effective' }
          assets = @parent.assets.where conditions
          items.each do |item|
            item['asset'] = assets.find { |a| a.id == item['assetId'] }
          end
        end
        super
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

      # @return [Hash] the parameters to submit to YouTube to add a claim.
      # @see https://developers.google.com/youtube/partner/docs/v1/claims/insert
      def insert_params
        super.tap do |params|
          params[:path] = '/youtube/partner/v1/claims'
        end
      end

      def claims_params
        apply_where_params! on_behalf_of_content_owner: @parent.owner_name
      end

      # @private
      # @todo: This is one of three places outside of base.rb where @where_params
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
