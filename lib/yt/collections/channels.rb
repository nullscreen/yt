require 'yt/collections/resources'

module Yt
  module Collections
    # Provides methods to interact with a collection of YouTube channels.
    #
    # Resources with channels are: {Yt::Models::Account accounts}.
    class Channels < Resources

    private

      # @return [Hash] the parameters to submit to YouTube to list channels.
      # @see https://developers.google.com/youtube/v3/docs/channels/list
      def list_params
        super.tap{|params| params[:params] = channels_params}
      end

      def channels_params
        resources_params.merge mine: true
      end
    end
  end
end