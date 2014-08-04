require 'yt/collections/base'
require 'yt/models/content_owner_detail'

module Yt
  module Collections
    class ContentOwnerDetails < Base

    private

      # @return [Yt::Models::ContentOwnerDetail] a new content detail
      #   initialized with one of the items returned by asking YouTube for a
      #   list of them.
      def new_item(data)
        Yt::ContentOwnerDetail.new data: data['contentOwnerDetails']
      end

      # @return [Hash] the parameters to submit to YouTube to get the
      #   content owner detail of a channel.
      # @see https://developers.google.com/youtube/v3/docs/channels#contentOwnerDetails
      def list_params
        super.tap do |params|
          params[:params] = content_owner_details_params
          params[:path] = '/youtube/v3/channels'
        end
      end

      def content_owner_details_params
        @parent.content_owner_details_params.tap do |params|
          params[:max_results] = 50
          params[:part] = 'contentOwnerDetails'
          params[:id] = @parent.id
        end
      end
    end
  end
end