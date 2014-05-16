require 'yt/collections/base'
require 'yt/models/id'

module Yt
  module Collections
    class Ids < Base

    private

      def new_item(data)
        Yt::Id.new data['id']
      end

      def list_params
        super.tap do |params|
          params[:params] = {forUsername: @parent.username, part: 'id'}
          params[:path] = "/youtube/v3/#{@parent.kind.pluralize}"
        end
      end
    end
  end
end
