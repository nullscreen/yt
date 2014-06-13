require 'yt/collections/base'
require 'yt/models/status'

module Yt
  module Collections
    class Statuses < Base

    private

      # @return [Yt::Models::Status] a new status initialized with
      #   one of the items returned by asking YouTube for a list of statuses,
      #   of a resource, for instance a channel.
      # @see https://developers.google.com/youtube/v3/docs/playlists#resource
      def new_item(data)
        Yt::Status.new data: data['status']
      end

      # @return [Hash] the parameters to submit to YouTube to get the status
      #   of a resource, for instance a channel.
      # @see https://developers.google.com/youtube/v3/docs/channels/list
      def list_params
        super.tap do |params|
          params[:params] = {id: @parent.id, part: 'status'}
          params[:path] = "/youtube/v3/#{@parent.kind.pluralize}"
        end
      end
    end
  end
end