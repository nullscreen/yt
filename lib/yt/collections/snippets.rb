require 'yt/collections/base'
require 'yt/models/snippet'

module Yt
  module Collections
    class Snippets < Base

    private

      # @return [Yt::Models::Snippet] a new snippet initialized with
      #   one of the items returned by asking YouTube for a list of snippets.
      def new_item(data)
        Yt::Snippet.new data: data['snippet']
      end

      # @return [Hash] the parameters to submit to YouTube to get the
      #   snippet of a resource, for instance a channel.
      # @see https://developers.google.com/youtube/v3/docs/channels#resource
      def list_params
        super.tap do |params|
          params[:params] = {id: @parent.id, part: 'snippet'}
          params[:path] = "/youtube/v3/#{@parent.kind.pluralize}"
        end
      end
    end
  end
end