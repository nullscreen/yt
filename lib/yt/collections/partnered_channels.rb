require 'yt/collections/channels'

module Yt
  module Collections
    class PartneredChannels < Channels

    private

      # @return [Hash] the parameters to submit to YouTube to list partnered channels.
      # @see https://developers.google.com/youtube/v3/docs/channels/list
      def list_params
        super.tap do |params|
          params[:params].delete :mine
          params[:params][:managedByMe] = true
          params[:params][:onBehalfOfContentOwner] = @parent.owner_name
        end
      end

      # @private
      # @note Partnered Channels overwrites +list_resources+ since the endpoint
      #   to hit is 'channels', not 'partnered_channels'.
      def list_resources
        self.class.superclass
      end
    end
  end
end