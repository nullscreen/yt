require 'yt/collections/base'
require 'yt/models/id'

module Yt
  module Collections
    # @private
    class Ids < Base

    private

      def attributes_for_new_item(data)
        data['id']
      end

      def list_params
        super.tap do |params|
          params[:params] = ids_params
          params[:path] = "/youtube/v3/#{@parent.kind.pluralize}"
        end
      end

      def ids_params
        {for_username: @parent.username, part: 'id'}
      end
    end
  end
end
