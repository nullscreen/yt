require 'yt/collections/base'

module Yt
  module Collections
    class Earnings < Base

      def within(days_range)
        @days_range = days_range
        Hash[*flat_map{|daily_earning| daily_earning}]
      end

    private

      def new_item(data)
        # NOTE: could use column headers to be more precise
        [Date.iso8601(data.first), data.last]
      end

      def list_params
        super.tap do |params|
          params[:path] = '/youtube/analytics/v1/reports'
          params[:params] = {}.tap do |params|
            params['ids'] = "contentOwner==#{@auth.owner_name}"
            params['filters'] = "channel==#{@parent.id}"
            params['start-date'] = @days_range.begin
            params['end-date'] = @days_range.end
            params['metrics'] = :earnings
            params['dimensions'] = :day
          end
        end
      end

      def items_key
        'rows'
      end
    end
  end
end