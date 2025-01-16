require 'yt/collections/base'
require 'yt/models/live_cuepoint'

module Yt
  module Collections
    # Provides methods to insert live cuepoints.
    #
    # Resources with live_cuepoints are: {Yt::Models::ContentOwner content owners}.
    class LiveCuepoints < Base
      def insert(attributes = {})
        underscore_keys! attributes
        body = attributes.slice(*body_params)
        params = {on_behalf_of_content_owner: @auth.owner_name}
        apply_where_params! params
        do_insert(params: params, body: body)
      end

      private

      def body_params
        [:id, :cue_type, :insertion_offset_time_ms, :walltime_ms, :duration_secs]
      end

      # @return [Hash] the parameters to submit to YouTube to add a live cuepoint.
      # @see https://developers.google.com/youtube/v3/live/docs/liveBroadcasts/cuepoint
      def insert_params
        super.tap do |params|
          params[:path] = '/youtube/v3/liveBroadcasts/cuepoint'
        end
      end

      def attributes_for_new_item(data)
        {data: data, auth: @auth, id: data['id']}
      end
    end
  end
end
