require 'yt/collections/channels'

module Yt
  module Collections
    class PartneredChannels < Channels

    private

      def list_params
        super.tap do |params|
          params[:params].delete :mine
          params[:params][:managedByMe] = true
          params[:params][:onBehalfOfContentOwner] = @parent.owner_name
        end
      end

      def list_resources
        self.class.superclass
      end
    end
  end
end