require 'yt/collections/base'
require 'yt/models/snippet'

module Yt
  module Collections
    class Snippets < Base

    private

      def new_item(data)
        Yt::Snippet.new data: data['snippet']
      end

      def list_params
        super.tap do |params|
          params[:params] = {id: @parent.id, part: 'snippet'}
          params[:path] = "/youtube/v3/#{@parent.kind.pluralize}"
        end
      end
    end
  end
end