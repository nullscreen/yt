require 'yt/collections/base'
require 'yt/models/bulk_report'

module Yt
  module Collections
    # @private
    class BulkReports < Base

    private

      def list_params
        super.tap do |params|
          params[:host] = 'youtubereporting.googleapis.com'
          params[:path] = "/v1/jobs/#{@parent.id}/reports"
          params[:params] = {on_behalf_of_content_owner: @parent.auth.owner_name}
        end
      end

      def items_key
        'reports'
      end
    end
  end
end
