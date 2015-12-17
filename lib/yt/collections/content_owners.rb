require 'yt/collections/base'
require 'yt/models/content_owner'

module Yt
  module Collections
    # Provides methods to interact with a collection of Content Owners.
    #
    # Resources with content_owners are: {Yt::Models::Account accounts}.
    class ContentOwners < Base

    private

      def attributes_for_new_item(data)
        {owner_name: data['id'], display_name: data['displayName'], authentication: @auth.authentication}
      end

      # @return [Hash] the parameters to submit to YouTube to list content
      #   owners administered by the account.
      # @see https://developers.google.com/youtube/partner/docs/v1/contentOwners/list
      def list_params
        super.tap do |params|
          params[:params] = content_owners_params
          params[:path] = '/youtube/partner/v1/contentOwners'
        end
      end

      def content_owners_params
        {fetch_mine: true}
      end
    end
  end
end