require 'yt/collections/base'

module Yt
  module Collections
    class Reports < Base
      attr_writer :metric

      def within(days_range, try_again = true)
        @days_range = days_range
        Hash[*flat_map{|daily_value| daily_value}]
      # NOTE: Once in a while, YouTube responds with 400 Error and the message
      # "Invalid query. Query did not conform to the expectations."; in this
      # case running the same query after one second fixes the issue. This is
      # not documented by YouTube and hardly testable, but trying again the
      # same query is a workaround that works and can hardly cause any damage.
      # Similarly, once in while YouTube responds with a random 503 error.
      rescue Yt::Error => e
        try_again && rescue?(e) ? sleep(3) && within(days_range, false) : raise
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
          params['metrics'] = @metric.to_s.camelize(:lower)
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

      def rescue?(error)
        'badRequest'.in?(error.reasons) && error.to_s =~ /did not conform/
      end
    end
  end
end