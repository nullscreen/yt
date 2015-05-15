module Yt
  module Associations
    # @private
    # Provides methods to access the analytics reports of a resource.
    module HasReports
      # @!macro [new] report
      #   Returns the $1 grouped by the given dimension.
      #   @!method $1(options = {})
      #   @param [Hash] options the time-range and dimensions for the $1.
      #   @option options [#to_date] :since The first day of the time-range.
      #     Also aliased as +:from+.
      #   @option options [#to_date] :until The last day of the time-range.
      #     Also aliased as +:to+.

      # @!macro [new] report_with_day
      #   @return [Hash<Date, $2>] if grouped by day, the $1
      #     for each day in the time-range.
      #   @example Get the $1 for each day of last week:
      #     resource.$1 since: 2.weeks.ago, until: 1.week.ago, by: :day
      #     # => {Wed, 8 May 2014 => 12.0, Thu, 9 May 2014 => 34.0, …}
      #   @macro report

      # @!macro [new] report_with_range
      #   @return [Hash<Symbol, $2>] if grouped by range, the $1
      #     for the entire time-range (under the key +:total+).
      #   @example Get the $1 for the whole last week:
      #     resource.$1 since: 2.weeks.ago, until: 1.week.ago, by: :range
      #     # => {total: 564.0}

      # @!macro [new] report_with_country
      #   @option options [<String, Hash>] :in The country to limit the $1
      #     to. Can either be the two-letter ISO-3166-1 code of a country, such
      #     as +"US"+, or a Hash with the code in the +:country+ key, such
      #     as +{country: "US"}+.
      #   @example Get the $1 for the whole last week in France only:
      #     resource.$1 since: 2.weeks.ago, until: 1.week.ago, by: :range, in: 'FR'
      #     # => {total: 44.0}

      # @!macro [new] report_with_country_and_state
      #   @option options [<String, Hash>] :in The location to limit the $1
      #     to. Can either be the two-letter ISO-3166-1 code of a country, such
      #     as +"US"+, or a Hash that either contains the +:country+ key, such
      #     as +{country: "US"}+ or the +:state+ key, such as +{state: "TX"}+.
      #     Note that YouTube API only provides data for US states.
      #   @example Get the $1 for the whole last week in Texas only:
      #     resource.$1 since: 2.weeks.ago, until: 1.week.ago, by: :range, in: {state: 'TX'}
      #     # => {total: 19.0}

      # @!macro [new] report_by_day
      #   @option options [Symbol] :by (:day) The dimension to collect $1 by.
      #     Accepted values are: +:day+.
      #   @macro report_with_day

      # @!macro [new] report_by_day_and_country
      #   @option options [Symbol] :by (:day) The dimension to collect $1 by.
      #     Accepted values are: +:day+, :+range+.
      #   @macro report_with_day
      #   @macro report_with_range
      #   @macro report_with_country

      # @!macro [new] report_by_day_and_state
      #   @option options [Symbol] :by (:day) The dimension to collect $1 by.
      #     Accepted values are: +:day+, :+range+.
      #   @macro report_with_day
      #   @macro report_with_range
      #   @macro report_with_country_and_state

      # @!macro [new] report_with_video_dimensions
      #   @return [Hash<Symbol, $2>] if grouped by playback location, the
      #     $1 for each traffic playback location.
      #   @example Get yesterday’s $1 grouped by playback location:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :playback_location
      #     # => {embedded: 53.0, watch: 467.0, …}
      #   @return [Hash<Yt::Video, $2>] if grouped by related video, the
      #     $1 for each related video.
      #   @example Get yesterday’s $1 by related video:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :related_video
      #     # => {#<Yt::Video @id=…> => 33.0, #<Yt::Video @id=…> => 12.0, …}
      #   @return [Hash<Yt::Video, $2>] if grouped by device type, the
      #     $1 for each device type.
      #   @example Get yesterday’s $1 by search term:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :search_term
      #     # => {"fullscreen" => 33.0, "good music" => 12.0, …}
      #   @return [Hash<String, $2>] if grouped by search term, the
      #     $1 for each search term that led viewers to the content.
      #   @example Get yesterday’s $1 by device type:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :device_type
      #     # => {mobile: 133.0, tv: 412.0, …}
      #   @return [Hash<Yt::Video, $2>] if grouped by traffic source, the
      #     $1 for each traffic source.
      #   @example Get yesterday’s $1 by traffic source:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :traffic_source
      #     # => {advertising: 543.0, playlist: 92.0, …}
      #   @macro report_with_day
      #   @macro report_with_range

      # @!macro [new] report_by_video_dimensions
      #   @option options [Symbol] :by (:day) The dimension to collect $1 by.
      #     Accepted values are: +:day+, +:range+, +:traffic_source+,
      #     +:search_term+, +:playback_location+, +:related_video+,
      #     +:embedded_player_location+.
      #   @return [Hash<Symbol, $2>] if grouped by embedded player location,
      #     the $1 for each embedded player location.
      #   @example Get yesterday’s $1 by embedded player location:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :embedded_player_location
      #     # => {"fullscreen.net" => 92.0, "yahoo.com" => 14.0, …}
      #   @macro report_with_video_dimensions
      #   @macro report_with_country_and_state

      # @!macro [new] report_with_channel_dimensions
      #   @return [Hash<Yt::Video, $2>] if grouped by video, the
      #     $1 for each video.
      #   @example Get yesterday’s $1 by video:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :video
      #     # => {#<Yt::Video @id=…> => 33.0, #<Yt::Video @id=…> => 12.0, …}
      #   @return [Hash<Yt::Video, $2>] if grouped by playlist, the
      #     $1 for each playlist.
      #   @example Get yesterday’s $1 by playlist:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :playlist
      #     # => {#<Yt::Video @id=…> => 33.0, #<Yt::Video @id=…> => 12.0, …}
      #   @macro report_with_video_dimensions

      # @!macro [new] report_by_channel_dimensions
      #   @option options [Symbol] :by (:day) The dimension to collect $1 by.
      #     Accepted values are: +:day+, +:range+, +:traffic_source+,
      #     +:search_term+, +:playback_location+, +:related_video+, +:video+,
      #     +:playlist+, +:embedded_player_location+.
      #   @return [Hash<Symbol, $2>] if grouped by embedded player location,
      #     the $1 for each embedded player location.
      #   @example Get yesterday’s $1 by embedded player location:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :embedded_player_location
      #     # => {"fullscreen.net" => 92.0, "yahoo.com" => 14.0, …}
      #   @macro report_with_channel_dimensions
      #   @macro report_with_country_and_state

      # @!macro [new] report_by_playlist_dimensions
      #   @option options [Symbol] :by (:day) The dimension to collect $1 by.
      #     Accepted values are: +:day+, +:range+, +:traffic_source+,
      #     +:playback_location+, +:related_video+, +:video+,
      #     +:playlist+.
      #   @macro report_with_channel_dimensions
      #   @macro report_with_country_and_state

      # @!macro [new] report_by_gender_and_age_group
      #   @option options [Symbol] :by (:gender_age_group) The dimension to
      #     show viewer percentage by.
      #     Accepted values are: +:gender+, +:age_group+, +:gender_age_group+.
      #   @return [Hash<Symbol, $2>] if grouped by gender, the
      #     viewer percentage by gender.
      #   @example Get yesterday’s viewer percentage by gender:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :gender
      #     # => {female: 53.0, male: 47.0}
      #   @return [Hash<String, $2>] if grouped by age group, the
      #     viewer percentage by age group.
      #   @example Get yesterday’s $1 grouped by age group:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :age_group
      #     # => {"18-24" => 4.54, "35-24" => 12.31, "45-34" => 8.92, …}
      #   @return [Hash<Symbol, [Hash<String, $2>]>] if grouped by gender
      #     and age group, the viewer percentage by gender/age group.
      #   @example Get yesterday’s $1 by gender and age group:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago
      #     # => {female: {"18-24" => 12.12, "25-34" => 16.16, …}, male:…}
      #   @example Get yesterday’s $1 by gender and age group in France only:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, in: 'FR'
      #     # => {female: {"18-24" => 16.12, "25-34" => 13.16, …}, male:…}
      #   @macro report
      #   @macro report_with_country_and_state

      # Defines two public instance methods to access the reports of a
      # resource for a specific metric.
      # @param [Symbol] metric the metric to access the reports of.
      # @param [Class] type The class to cast the returned values to.
      # @example Adds +comments+ and +comments_on+ on a Channel resource.
      #   class Channel < Resource
      #     has_report :comments, Integer
      #   end
      def has_report(metric, type)
        require 'yt/collections/reports'

        define_metric_on_method metric
        define_metric_method metric
        define_range_metric_method metric, type
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
          location = options[:in]
          country = location.is_a?(Hash) ? location[:country] : location
          state = location[:state] if location.is_a?(Hash)

          range = Range.new *[from, to].map(&:to_date)
          dimension = options[:by] || (metric == :viewer_percentage ? :gender_age_group : :day)

          ivar = instance_variable_get "@#{metric}_#{dimension}_#{country}_#{state}"
          instance_variable_set "@#{metric}_#{dimension}_#{country}_#{state}", ivar || {}

          case dimension
          when :day
            Hash[*range.flat_map do |date|
              [date, instance_variable_get("@#{metric}_#{dimension}_#{country}_#{state}")[date] ||= send("range_#{metric}", range, dimension, country, state)[date]]
            end]
          else
            instance_variable_get("@#{metric}_#{dimension}_#{country}_#{state}")[range] ||= send("range_#{metric}", range, dimension, country, state)
          end
        end
      end

      def define_range_metric_method(metric, type)
        define_method "range_#{metric}" do |date_range, dimension, country, state|
          ivar = instance_variable_get "@range_#{metric}_#{dimension}_#{country}_#{state}"
          instance_variable_set "@range_#{metric}_#{dimension}_#{country}_#{state}", ivar || {}
          instance_variable_get("@range_#{metric}_#{dimension}_#{country}_#{state}")[date_range] ||= send("all_#{metric}").within date_range, country, state, dimension, type
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