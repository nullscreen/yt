require 'yt/collections/base'
require 'yt/models/video'

module Yt
  module Collections
    # Provides methods to interact with a collection of YouTube live broadcasts.
    #
    # Resources with live broadcasts are: {Yt::Models::Channel channels} and
    # {Yt::Models::Account accounts}.
    class LiveBroadcasts < Resources

      private

      # @return [Hash] the parameters to submit to YouTube to list live broadcasts.
      # @see https://developers.google.com/youtube/v3/docs/liveBroadcasts/list
      def list_params
        super.tap{|params| params[:params] = live_broadcasts_params}
      end

      def live_broadcasts_params
        if @where_params.blank?
          {broadcastType: "all", mine: true}
        else
          apply_where_params! on_behalf_of_content_owner: @parent.owner_name
        end
      end

      def attributes_for_new_item(data)
        {}.tap do |attributes|
          attributes[:id] = data['id']
          attributes[:snippet] = data['snippet']
          attributes[:status] = data['status']
          attributes[:content_details] = data['contentDetails']
        end
      end

      def insert_parts
        snippet = {keys: [:title, :description, :scheduled_start_time, :scheduled_end_time, :default_language], sanitize_brackets: true}
        status = {keys: [:privacy_status, :self_declared_made_for_kids]}
        {snippet: snippet, status: status}
      end
    end

  end
end
