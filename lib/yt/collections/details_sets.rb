require 'yt/collections/resources'
require 'yt/models/details_set'

module Yt
  module Collections
    class DetailsSets < Resources

    private

      def new_item(data)
        Yt::DetailsSet.new data: data['contentDetails']
      end

      def list_params
        super.tap do |params|
          params[:params] = {maxResults: 50, part: 'contentDetails', id: @parent.id}
          params[:scope] = 'https://www.googleapis.com/auth/youtube.readonly'
          params[:path] = '/youtube/v3/videos'
        end
      end
    end
  end
end