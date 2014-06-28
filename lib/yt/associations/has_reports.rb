module Yt
  module Associations
    # Provides methods to to access the analytics reports of a resource.
    #
    # YouTube resources with reports are: {Yt::Models::Channel channels} and
    #  {Yt::Models::Channel videos}.
    module HasReports
      # @!macro has_report
      #   @!method $1_on(date)
      #     @return [Float] the $1 for a single day.
      #     @param [#to_date] date The single day to get the $1 for.
      #   @!method $1(options = {})
      #     @return [Hash<Date, Float>] the $1 for a range of a days.
      #     @param [Hash] options the range of days to get the $1 for.
      #     @option options [#to_date] :since The first day of the range.
      #       Also aliased as *:from*.
      #     @option options [#to_date] :until The last day of the range.
      #       Also aliased as *:to*.

      # Defines two public instance methods to access the reports of a
      # resource for a specific metric.
      # @param [Symbol] metric the metric to access the reports of.
      # @example Adds +earnings+ and +earnings_on+ on a Channel resource.
      #   class Channel < Resource
      #     has_report :earnings
      #   end
      def has_report(metric)
        require 'yt/collections/reports'

        define_metric_on_method metric
        define_metric_method metric
        define_range_metric_method metric
        define_all_metric_method metric
      end

    private

      def define_metric_on_method(metric)
        define_method "#{metric}_on" do |date|
          send(metric, from: date, to: date).values.first
        end
      end

      def define_metric_method(metric)
        define_method metric do |options = {}|
          from = options[:since] || options[:from] || 5.days.ago
          to = options[:until] || options[:to] || 1.day.ago
          range = Range.new *[from, to].map(&:to_date)

          ivar = instance_variable_get "@#{metric}"
          instance_variable_set "@#{metric}", ivar || {}

          Hash[*range.flat_map do |date|
            [date, instance_variable_get("@#{metric}")[date] ||= send("range_#{metric}", range)[date]]
          end]
        end
      end

      def define_range_metric_method(metric)
        define_method "range_#{metric}" do |date_range|
          ivar = instance_variable_get "@range_#{metric}"
          instance_variable_set "@range_#{metric}", ivar || {}
          instance_variable_get("@range_#{metric}")[date_range] ||= send("all_#{metric}").within date_range
        end
        private "range_#{metric}"
      end

      def define_all_metric_method(metric)
        define_method "all_#{metric}" do
          # @note Asking for the "earnings" metric of a day in which a channel
          # made 0 USD returns the wrong "nil". But adding to the request the
          # "estimatedMinutesWatched" metric returns the correct value 0.
          query = metric
          query = "estimatedMinutesWatched,#{metric}" if metric == :earnings
          Collections::Reports.of(self).tap{|reports| reports.metric = query}
        end
        private "all_#{metric}"
      end
    end
  end
end