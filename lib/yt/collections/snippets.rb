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
        parents_path = @parent.class.to_s.demodulize.underscore.pluralize
        super.tap do |params|
          params[:params] = {id: @parent.id, part: 'snippet'}
          params[:scope] = 'https://www.googleapis.com/auth/youtube.readonly'
          params[:path] = "/youtube/v3/#{parents_path}"
        end
      end
    end
  end
end