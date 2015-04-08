require 'yt/collections/channels'

module Yt
  module Collections
    class PartneredChannels < Channels

    private

      def attributes_for_new_item(data)
        super(data).tap do |attributes|
          attributes[:viewer_percentages] = data['viewerPercentages']
        end
      end

      def eager_load_items_from(items)
        if included_relationships.include? :viewer_percentages
          filters = "channel==#{items.map{|item| item['id']}.join(',')}"
          ids = "contentOwner==#{@auth.owner_name}"
          conditions = {ids: ids, filters: filters}
          viewer_percentages = Collections::ViewerPercentages.new auth: @auth
          viewer_percentages = viewer_percentages.where conditions
          items.each do |item|
            item['viewerPercentages'] = viewer_percentages[item['id']]
          end
        end
        super
      end

      # @private
      # @note Partnered Channels overwrites +channel_params+ since the query
      #   is slightly different.
      def channels_params
        super.tap do |params|
          params.delete :mine
          params[:managed_by_me] = true
          params[:on_behalf_of_content_owner] = @auth.owner_name
        end
      end

      # @private
      # @note Partnered Channels overwrites +list_resources+ since the endpoint
      #   to hit is 'channels', not 'partnered_channels'.
      def list_resources
        self.class.superclass.to_s.demodulize
      end
    end
  end
end