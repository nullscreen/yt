require 'yt/collections/resources'
require 'yt/models/advertising_options_set'

module Yt
  module Collections
    # Provides methods to interact with a the advertising options of a YouTube video.
    #
    # Resources with advertising options are: {Yt::Models::Video videos}.
    class AdvertisingOptionsSets < Resources

    private

      def attributes_for_new_item(data)
        {data: data, video_id: @parent.id, auth: @auth}
      end

      # @return [Hash] the parameters to submit to YouTube to get video advertising options.
      # @see https://developers.google.com/youtube/partner/docs/v1/videoAdvertisingOptions/get
      def list_params
        super.tap do |params|
          params[:path] = "/youtube/partner/v1/videoAdvertisingOptions/#{@parent.id}"
          params[:params] = {on_behalf_of_content_owner: @auth.owner_name}
        end
      end

      # @private
      # @note AdvertisingOptionsSets overwrites +fetch_page+ since it’s a get.
      def fetch_page(params = {})
        response = list_request(params).run
        {items: [response.body], token: nil}
      end
    end
  end
end
