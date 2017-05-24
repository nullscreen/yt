require 'yt/collections/resources'
require 'yt/models/content_owner_advertising_options_set'

module Yt
  module Collections
    # Provides methods to interact with a the content owner advertising options of a YouTube video.
    #
    # Resources with advertising options are: {Yt::Models::ContentOwner}.
    class ContentOwnerAdvertisingOptionsSets < Resources

    private

      def attributes_for_new_item(data)
        {data: data, auth: @auth}
      end

      # @return [Hash] the parameters to submit to YouTube to get content owner advertising options.
      # @see https://developers.google.com/youtube/partner/docs/v1/contentOwnerAdvertisingOptions/get
      def list_params
        super.tap do |params|
          params[:path] = "/youtube/partner/v1/contentOwnerAdvertisingOptions"
          params[:params] = {on_behalf_of_content_owner: @auth.owner_name}
        end
      end

      # @private
      # @note ContentOwnerAdvertisingOptionsSets overwrites +fetch_page+ since it’s a get.
      def fetch_page(params = {})
        response = list_request(params).run
        {items: [response.body], token: nil}
      end
    end
  end
end
