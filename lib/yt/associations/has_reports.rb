module Yt
  module Associations
    # Provides methods to access the analytics reports of a resource.
    #
    # YouTube resources with reports are: {Yt::Models::Channel channels} and
    # {Yt::Models::Channel videos}.
    module HasReports
      # @!macro [new] report
      #   Returns the $1 of the video grouped by the given dimension.
      #   @!method $1(options = {})
      #   @param [Hash] options the time-range and dimensions for the $1.
      #   @option options [#to_date] :since The first day of the time-range.
      #     Also aliased as +:from+.
      #   @option options [#to_date] :until The last day of the time-range.
      #     Also aliased as +:to+.

      # @!macro [new] daily_report
      #   @option options [Symbol] :by (:day) The dimension to collect $1 by.
      #     Accepted values are: +:day+.
      #   @return [Hash<Date, Float>] if grouped by day, the $1 of the video
      #     for each day in the time-range.
      #   @example Get the video’s $1 for each day of last week:
      #     video.$1 since: 2.weeks.ago, until: 1.week.ago, by: :day
      #     # => {Wed, 8 May 2014 => 12.0, Thu, 9 May 2014 => 34.2, …}
      #   @macro report

      # @!macro [new] views_report
      #   @option options [Symbol] :by (:day) The dimension to collect $1 by.
      #     Accepted values are: +:day+, +:traffic_source+,
      #     +:playback_location+,+:embedded_player_location+, +:related_video+.
      #   @return [Hash<Date, Float>] if grouped by day, the $1 of the video
      #     for each day in the time-range.
      #   @example Get the video’s $1 for each day of last week:
      #     video.$1 since: 2.weeks.ago, until: 1.week.ago, by: :day
      #     # => {Wed, 8 May 2014 => 12.0, Thu, 9 May 2014 => 34.2, …}
      #   @return [Hash<Symbol, Float>] if grouped by traffic source, the
      #     $1 of the video for each traffic source.
      #   @example Get yesterday’s video’s $1 grouped by traffic source:
      #     video.$1 from: 1.day.ago, to: 1.day.ago, by: :traffic_source
      #     # => {advertising: 53.0, channel: 7.0, …}
      #   @return [Hash<Symbol, Float>] if grouped by playback location, the
      #     $1 of the video for each traffic playback location.
      #   @example Get yesterday’s video’s $1 grouped by playback location:
      #     video.$1 from: 1.day.ago, to: 1.day.ago, by: :playback_location
      #     # => {embedded: 53.0, watch: 467.0, …}
      #   @return [Hash<Symbol, Float>] if grouped by embedded player location,
      #     the $1 of the video for each embedded player location.
      #   @example Get yesterday’s video’s $1 by embedded player location:
      #     video.$1 from: 1.day.ago, to: 1.day.ago, by: :embedded_player_location
      #     # => {"fullscreen.net" => 92.0, "yahoo.com" => 14.0, …}
      #   @return [Hash<Yt::Video, Float>] if grouped by related video, the
      #     $1 of the video for each related video.
      #   @example Get yesterday’s video’s $1 by related video:
      #     video.$1 from: 1.day.ago, to: 1.day.ago, by: :related_video
      #     # => {#<Yt::Video @id=…> => 33.0, #<Yt::Video @id=…> => 12.0, …}
      #   @macro report

      # @!macro [new] demographics_report
      #   @option options [Symbol] :by (:gender_age_group) The dimension to
      #     show viewer percentage by.
      #     Accepted values are: +:gender+, +:age_group+, +:gender_age_group+.
      #   @return [Hash<Symbol, Float>] if grouped by gender, the video’s
      #     viewer percentage by gender.
      #   @example Get yesterday’s video’s viewer percentage by gender:
      #     video.$1 from: 1.day.ago, to: 1.day.ago, by: :gender
      #     # => {female: 53.0, male: 47.0}
      #   @return [Hash<String, Float>] if grouped by age group, the video’s
      #     viewer percentage by age group.
      #   @example Get yesterday’s video’s $1 grouped by age group:
      #     video.$1 from: 1.day.ago, to: 1.day.ago, by: :age_group
      #     # => {"18-24" => 4.54, "35-24" => 12.31, "45-34" => 8.92, …}
      #   @return [Hash<Symbol, [Hash<String, Float>]>] if grouped by gender
      #     and age group, the video’s viewer percentage by gender/age group.
      #   @example Get yesterday’s video’s $1 by gender and age group:
      #     video.$1 from: 1.day.ago, to: 1.day.ago
      #     # => {female: {"18-24" => 12.12, "25-34" => 16.16, …}, male:…}
      #   @macro report

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
          from = options[:since] || options[:from] || (metric == :viewer_percentage ? 3.months.ago : 5.days.ago)
          to = options[:until] || options[:to] || (metric == :viewer_percentage ? Date.today : 1.day.ago)
          range = Range.new *[from, to].map(&:to_date)
          dimension = options[:by] || (metric == :viewer_percentage ? :gender_age_group : :day)

          ivar = instance_variable_get "@#{metric}_#{dimension}"
          instance_variable_set "@#{metric}_#{dimension}", ivar || {}

          case dimension
          when :day
            Hash[*range.flat_map do |date|
              [date, instance_variable_get("@#{metric}_#{dimension}")[date] ||= send("range_#{metric}", range, dimension)[date]]
            end]
          else
            instance_variable_get("@#{metric}_#{dimension}")[range] ||= send("range_#{metric}", range, dimension)
          end
        end
      end

      def define_range_metric_method(metric)
        define_method "range_#{metric}" do |date_range, dimension|
          ivar = instance_variable_get "@range_#{metric}_#{dimension}"
          instance_variable_set "@range_#{metric}_#{dimension}", ivar || {}
          instance_variable_get("@range_#{metric}_#{dimension}")[date_range] ||= send("all_#{metric}").within date_range, dimension
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