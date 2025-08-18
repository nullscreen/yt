require 'yt/collections/base'
require 'yt/models/branding_setting'

module Yt
  module Collections
    # @private
    class BrandingSettings < Base

    private

      def attributes_for_new_item(data)
        puts data
        { data: data['brandingSettings'] }
      end

      # @return [Hash] the parameters to submit to YouTube to get the
      #   branding_settings of a resource, for instance a channel.
      # @see https://developers.google.com/youtube/v3/docs/channels#resource
      def list_params
        super.tap do |params|
          params[:path] = "/youtube/v3/#{@parent.kind.pluralize}"
          params[:params] = branding_settings_params
        end
      end

      def branding_settings_params
        { max_results: 50, part: 'brandingSettings', id: @parent.id }
      end
    end
  end
end
