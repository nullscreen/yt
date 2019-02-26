require 'yt/collections/base'
require 'yt/models/group_item'

module Yt
  module Collections
    # @private
    class GroupItems < Base

    private

      def attributes_for_new_item(data)
        super(data).tap do |attributes|
          attributes[:video] = data['video']
        end
      end

      def list_params
        super.tap do |params|
          params[:host] = 'youtubeanalytics.googleapis.com'
          params[:path] = "/v2/groupItems"
          params[:params] = {group_id: @parent.id}
          if @auth.owner_name
            params[:params][:on_behalf_of_content_owner] = @auth.owner_name
          end
        end
      end

      def eager_load_items_from(items)
        if included_relationships.include?(:video)
          all_video_ids = items.map{|item| item['resource']['id']}.uniq
          all_video_ids.each_slice(50) do |video_ids|
            conditions = {id: video_ids.join(',')}
            conditions[:part] = 'snippet,status,statistics,contentDetails'
            videos = Collections::Videos.new(auth: @auth).where conditions
            items.each do |item|
              video = videos.find{|v| v.id == item['resource']['id']}
              item['video'] = video if video
            end
          end
        end
        super
      end
    end
  end
end
