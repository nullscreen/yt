require 'yt/collections/channels'

module Yt
  module Collections
    class PartneredChannels < Channels

    private

      # @private
      # @note Partnered Channels overwrites +channel_params+ since the query
      #   is slightly different.
      def channels_params
        super.tap do |params|
          params.delete :mine
          params[:managed_by_me] = true
          params[:on_behalf_of_content_owner] = @auth.owner_name
        end
      end

      # @private
      # @note Partnered Channels overwrites +list_resources+ since the endpoint
      #   to hit is 'channels', not 'partnered_channels'.
      def list_resources
        self.class.superclass.to_s.demodulize
      end
    end
  end
end