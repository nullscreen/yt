require 'yt/models/base'

module Yt
  module Models
    # Encapsulates the default advertising options of a content owner, such as the
    # types of ads that can run on uploaded videos & claimed, user-uploaded content
    # as well as the the defaults for newly claimed videos
    # @see https://developers.google.com/youtube/partner/docs/v1/contentOwnerAdvertisingOptions
    class ContentOwnerAdvertisingOptionsSet < Base
      def initialize(options = {})
        @auth = options[:auth]
        @data = options[:data]
      end

      def update(attributes = {})
        underscore_keys! attributes
        do_patch(body: attributes) {|data| @data = data}
        true
      end

      # @return [String] the value that YouTube uses to uniquely identify the content owner.
      has_attribute :id

      # @return [ClaimedVideoDefaultsSet] This object identifies the advertising options used by default for the content owner's newly claimed videos.
      has_attribute :claimed_video_options do |options_set|
        ClaimedVideoDefaultsSet.new data: options_set
      end

      # @return [AllowedAdvertisingOptionsSet] This object identifies the ad formats that the content owner is allowed to use.
      has_attribute :allowed_options do |options_set|
        AllowedAdvertisingOptionsSet.new data: options_set
      end

      private
        # @see https://developers.google.com/youtube/partner/docs/v1/contentOwnerAdvertisingOptions/patch
        def patch_params
          super.tap do |params|
            params[:expected_response] = Net::HTTPOK
            params[:path] = "/youtube/partner/v1/contentOwnerAdvertisingOptions"
            params[:params] = {on_behalf_of_content_owner: @auth.owner_name}
          end
        end
    end
  end
end
