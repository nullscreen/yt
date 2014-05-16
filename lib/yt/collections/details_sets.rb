require 'yt/collections/base'
require 'yt/models/details_set'

module Yt
  module Collections
    class DetailsSets < Base

    private

      def new_item(data)
        Yt::DetailsSet.new data: data['contentDetails']
      end

      def list_params
        super.tap do |params|
          params[:params] = {maxResults: 50, part: 'contentDetails', id: @parent.id}
          params[:path] = '/youtube/v3/videos'
        end
      end
    end
  end
end