require 'yt/models/base'

module Yt
  module Models
    # Encapsulates advertising options of a video, such as the types of ads
    # that can run during the video as well as the times when ads are allowed
    # to run during the video.
    # @see https://developers.google.com/youtube/partner/docs/v1/videoAdvertisingOptions#resource
    class AdvertisingOptionsSet < Base
      def initialize(options = {})
        @auth = options[:auth]
        @video_id = options[:video_id]
        @data = options[:data]
      end

      def update(attributes = {})
        underscore_keys! attributes
        do_patch(body: attributes) {|data| @data = data}
        true
      end

      # Return the list of ad formats that the video is allowed to show.
      # Valid values for this property are: long, overlay, standard_instream,
      # third_party, trueview_inslate, or trueview_instream.
      # @return [Array<String>] the list of ad formats that the video is
      #   allowed to show.
      def ad_formats
        @data['adFormats']
      end

    private

      # @see https://developers.google.com/youtube/partner/docs/v1/videoAdvertisingOptions/patch
      def patch_params
        super.tap do |params|
          params[:expected_response] = Net::HTTPOK
          params[:path] = "/youtube/partner/v1/videoAdvertisingOptions/#{@video_id}"
          params[:params] = {on_behalf_of_content_owner: @auth.owner_name}
        end
      end
    end
  end
end