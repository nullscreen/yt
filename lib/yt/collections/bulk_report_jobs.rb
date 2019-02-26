require 'yt/collections/base'
require 'yt/models/bulk_report_job'

module Yt
  module Collections
    # @private
    class BulkReportJobs < Base

    private

      def attributes_for_new_item(data)
        {id: data['id'], auth: @auth, report_type_id: data['reportTypeId']}
      end

      def list_params
        super.tap do |params|
          params[:host] = 'youtubereporting.googleapis.com'
          params[:path] = "/v1/jobs"
          params[:params] = {on_behalf_of_content_owner: @parent.owner_name}
        end
      end

      def items_key
        'jobs'
      end
    end
  end
end
