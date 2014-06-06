require 'yt/collections/base'
require 'yt/models/status'

module Yt
  module Collections
    class Statuses < Base

    private

      def new_item(data)
        Yt::Status.new data: data['status']
      end

      def list_params
        super.tap do |params|
          params[:params] = {id: @parent.id, part: 'status'}
          params[:path] = "/youtube/v3/#{@parent.kind.pluralize}"
        end
      end
    end
  end
end