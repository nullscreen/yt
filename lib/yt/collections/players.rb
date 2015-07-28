require 'yt/collections/base'
require 'yt/models/player'

module Yt
  module Collections
    # @private
    class Players < Base

    private

      def attributes_for_new_item(data)
        {data: data['player']}
      end

      # @return [Hash] the parameters to submit to YouTube to get the
      #   statistics of a resource, for instance a video.
      # @see https://developers.google.com/youtube/v3/docs/videos#resource
      def list_params
        super.tap do |params|
          params[:path] = "/youtube/v3/#{@parent.kind.pluralize}"
          params[:params] = players_params
        end
      end

      def players_params
        {max_results: 50, part: 'player', id: @parent.id}
      end
    end
  end
end
