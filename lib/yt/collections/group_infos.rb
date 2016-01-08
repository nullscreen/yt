require 'yt/collections/base'
require 'yt/models/snippet'

module Yt
  module Collections
    # @private
    class GroupInfos < Base

    private

      def attributes_for_new_item(data)
        {data: data, auth: @auth}
      end

      def list_params
        super.tap do |params|
          params[:path] = "/youtube/analytics/v1/groups"
          params[:params] = {id: @parent.id}
          if @auth.owner_name
            params[:params][:on_behalf_of_content_owner] = @auth.owner_name
          end
        end
      end
    end
  end
end