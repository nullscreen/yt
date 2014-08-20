require 'yt/models/base'
require 'yt/actions/get'

module Yt
  module Models
    # The advertising settings for a video. The settings identify the types 
    # of ads that can run during the video as well as the times when ads are allowed to run during the video
    # @see https://developers.google.com/youtube/partner/docs/v1/videoAdvertisingOptions
    class VideoAdvertisingOptions < Base
      include Actions::Get
      def initialize(options = {})
        @video_id = options[:video_id]
        @auth = options[:auth]
        do_get() {|data| @data = data}
      end

      # update the advertising options
      def update(attributes = {})

        body = @data.deep_merge(attributes)
        do_update(body: body) do |data|
          @data = data
        end

        true
      end

    private

      def get_params
        super.tap do |params|
          params[:path] = "/youtube/partner/v1/videoAdvertisingOptions/#{@video_id}"
          params[:params] = {onBehalfOfContentOwner: @auth.owner_name}
        end
      end

      # @return [Hash] the parameters to submit to YouTube to update advertising options
      # @see https://developers.google.com/youtube/partner/docs/v1/videoAdvertisingOptions/update
      def update_params
        super.tap do |params|
          params[:path] = "/youtube/partner/v1/videoAdvertisingOptions/#{@video_id}/"
          params[:params] = {onBehalfOfContentOwner: @auth.owner_name}
          params[:expected_response] = Net::HTTPOK
        end
      end

    end
  end
end