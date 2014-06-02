require 'yt/collections/base'

module Yt
  module Collections
    class Earnings < Base

      def within(days_range, try_again = true)
        @days_range = days_range
        Hash[*flat_map{|daily_earning| daily_earning}]
      # NOTE: Once in a while, YouTube responds with 400 Error and the message
      # "Invalid query. Query did not conform to the expectations."; in this
      # case running the same query after one second fixes the issue. This is
      # not documented by YouTube and hardly testable, but trying again the
      # same query is a workaround that works and can hardly cause any damage.
      rescue Yt::Error => e
        try_again && rescue?(e) ? sleep(3) && within(days_range, false) : raise
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
            params['metrics'] = [:estimatedMinutesWatched, :earnings].join ','
            params['dimensions'] = :day
          end
        end
      end

      def items_key
        'rows'
      end

      def rescue?(error)
        'badRequest'.in?(error.reasons) && error.message =~ /did not conform/
      end
    end
  end
end