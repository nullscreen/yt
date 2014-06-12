require 'yt/collections/base'
require 'yt/models/channel'

module Yt
  module Collections
    # Provides methods to interact with a collection of YouTube channels.
    # Resources with channels are: {Yt::Models::Account accounts}.
    class Channels < Base

    private

      # @return [Yt::Models::Channel] a new channel initialized with one of
      #   the items returned by asking YouTube for a list of channels.
      # @see https://developers.google.com/youtube/v3/docs/channels#resource
      def new_item(data)
        Yt::Channel.new id: data['id'], snippet: data['snippet'], auth: @auth
      end

      # @return [Hash] the parameters to submit to YouTube to list channels.
      # @see https://developers.google.com/youtube/v3/docs/channels/list
      def list_params
        super.tap do |params|
          params[:params] = {maxResults: 50, part: 'snippet', mine: true}
        end
      end
    end
  end
end