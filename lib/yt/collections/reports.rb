require 'yt/collections/base'

module Yt
  module Collections
    class Reports < Base

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
          params[:params] = {}.tap do |params|
            params['ids'] = "contentOwner==#{@auth.owner_name}"
            params['filters'] = "channel==#{@parent.id}"
            params['start-date'] = @days_range.begin
            params['end-date'] = @days_range.end
            params['metrics'] = metrics
            params['dimensions'] = :day
          end
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

      def metrics
        ''
      end

      def items_key
        'rows'
      end
    end
  end
end