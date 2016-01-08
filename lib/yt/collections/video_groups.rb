require 'yt/collections/base'
require 'yt/models/video_group'
require 'yt/models/group_info'

module Yt
  module Collections
    # @private
    class VideoGroups < Base

    private

      def attributes_for_new_item(data)
        {id: data['id'], auth: @auth, group_info: Yt::GroupInfo.new(data: data)}
      end

      def new_item(data)
        super if data['contentDetails']['itemType'] == 'youtube#video'
      end

      def list_params
        super.tap do |params|
          params[:path] = "/youtube/analytics/v1/groups"
          params[:params] = @parent.video_groups_params
        end
      end
    end
  end
end
