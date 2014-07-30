require 'yt/collections/base'

module Yt
  module Collections
    class Reports < Base
      attr_writer :metric

      def within(days_range)
        @days_range = days_range
        Hash[*flat_map{|daily_value| daily_value}]
      end

    private

      def new_item(data)
        [day_of(data), value_of(data)]
      end

      # @see https://developers.google.com/youtube/analytics/v1/content_owner_reports
      def list_params
        super.tap do |params|
          params[:path] = '/youtube/analytics/v1/reports'
          params[:params] = reports_params
          params[:camelize_params] = false
        end
      end

      def reports_params
        @parent.reports_params.tap do |params|
          params['start-date'] = @days_range.begin
          params['end-date'] = @days_range.end
          params['metrics'] = @metric
          params['dimensions'] = :day
        end
      end

      def day_of(data)
        # NOTE: could use column headers to be more precise
        Date.iso8601 data.first
      end

      def value_of(data)
        # NOTE: could use column headers to be more precise
        data.last
      end

      def items_key
        'rows'
      end
    end
  end
end