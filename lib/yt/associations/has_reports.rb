module Yt
  module Associations
    # @private
    # Provides methods to access the analytics reports of a resource.
    module HasReports
      # @!macro [new] reports
      #   Returns the reports for the given metrics grouped by the given dimension.
      #   @!method reports(options = {})
      #   @param [Hash] options the metrics, time-range and dimensions for the reports.
      #   @option options [Array<Symbol>] :only The metrics to generate reports
      #     for.
      #   @option options [Symbol] :by (:day) The dimension to collect metrics
      #     by. Accepted values are: +:day+, +:week+, +:month+.
      #   @option options [#to_date] :since The first day of the time-range.
      #     Also aliased as +:from+.
      #   @option options [#to_date] :until The last day of the time-range.
      #     Also aliased as +:to+.
      #   @return [Hash<Symbol, Hash>] the reports for each metric specified.
      #   @example Get the views and estimated minutes watched by day for last week:
      #     resource.reports only: [:views, :estimated_minutes_watched] since: 1.week.ago, by: :day
      #     # => {views: {Wed, 8 May 2014 => 12, Thu, 9 May 2014 => 34, …}, estimated_minutes_watched: {Wed, 8 May 2014 => 9, Thu, 9 May 2014 => 6, …}}

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
      #   @return [Hash<Range<Date, Date>, $2>] if grouped by month, the $1
      #     for each month in the time-range.
      #   @example Get the $1 for this and last month:
      #     resource.$1 since: 1.month.ago, by: :month
      #     # => {Wed, 01 Apr 2014..Thu, 30 Apr 2014 => 12.0, Fri, 01 May 2014..Sun, 31 May 2014 => 34.0, …}
      #   @return [Hash<Range<Date, Date>, $2>] if grouped by week, the $1
      #     for each week in the time-range.
      #   @example Get the $1 for this and last week:
      #     resource.$1 since: 1.week.ago, by: :week
      #     # => {Wed, 01 Apr 2014..Tue, 07 Apr 2014 => 20.0, Wed, 08 Apr 2014..Tue, 14 Apr 2014 => 13.0, …}
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
      #     Accepted values are: +:day+, +:week+, +:month+.
      #   @macro report_with_day

      # @!macro [new] report_by_day_and_country
      #   @option options [Symbol] :by (:day) The dimension to collect $1 by.
      #     Accepted values are: +:day+, +:week+, +:month+, :+range+.
      #   @macro report_with_day
      #   @macro report_with_range
      #   @macro report_with_country

      # @!macro [new] report_by_day_and_state
      #   @option options [Symbol] :by (:day) The dimension to collect $1 by.
      #     Accepted values are: +:day+, +:week+, +:month+, :+range+.
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
      #   @example Get yesterday’s $1 by related video, eager-loading the snippet of each video::
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :related_video, includes: [:snippet]
      #     # => {#<Yt::Video @id=…> => 33.0, #<Yt::Video @id=…> => 12.0, …}
      #   @return [Hash<Symbol, $2>] if grouped by device type, the
      #     $1 for each device type.
      #   @example Get yesterday’s $1 by search term:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :search_term
      #     # => {"fullscreen" => 33.0, "good music" => 12.0, …}
      #   @return [Hash<String, $2>] if grouped by search term, the
      #     $1 for each search term that led viewers to the content.
      #   @example Get yesterday’s $1 by URL that referred to the resource:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :referrer
      #     # => {"Google Search" => 33.0, "ytimg.com" => 12.0, …}
      #   @return [Hash<String, $2>] if grouped by search term, the
      #     $1 for each search term that led viewers to the content.
      #   @example Get yesterday’s $1 by device type:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :device_type
      #     # => {mobile: 133.0, tv: 412.0, …}
      #   @return [Hash<Symbol, $2>] if grouped by traffic source, the
      #     $1 for each traffic source.
      #   @example Get yesterday’s $1 by traffic source:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :traffic_source
      #     # => {advertising: 543.0, playlist: 92.0, …}
      #   @macro report_with_day
      #   @macro report_with_range

      # @!macro [new] report_by_video_dimensions
      #   @option options [Symbol] :by (:day) The dimension to collect $1 by.
      #     Accepted values are: +:day+, +:week+, +:month+, +:range+,
      #     +:traffic_source+,+:search_term+, +:playback_location+,
      #     +:related_video+, +:embedded_player_location+.
      #   @option options [Array<Symbol>] :includes ([:id]) if grouped by
      #     related video, the parts of each video to eager-load. Accepted
      #     values are: +:id+, +:snippet+, +:status+, +:statistics+,
      #     +:content_details+.
      #   @return [Hash<Symbol, $2>] if grouped by embedded player location,
      #     the $1 for each embedded player location.
      #   @example Get yesterday’s $1 by embedded player location:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :embedded_player_location
      #     # => {"fullscreen.net" => 92.0, "yahoo.com" => 14.0, …}
      #   @macro report_with_video_dimensions
      #   @macro report_with_country_and_state

      # @!macro [new] report_with_channel_dimensions
      #   @option options [Array<Symbol>] :includes ([:id]) if grouped by
      #     video, related video, or playlist, the parts of each video or
      #     playlist to eager-load. Accepted values are: +:id+, +:snippet+,
      #     +:status+, +:statistics+, +:content_details+.
      #   @return [Hash<Yt::Video, $2>] if grouped by video, the
      #     $1 for each video.
      #   @example Get yesterday’s $1 by video, eager-loading the status and statistics of each video:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :video, includes: [:status, :statistics]
      #     # => {#<Yt::Video @id=…> => 33.0, #<Yt::Video @id=…> => 12.0, …}
      #   @return [Hash<Yt::Playlist, $2>] if grouped by playlist, the
      #     $1 for each playlist.
      #   @example Get yesterday’s $1 by playlist:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :playlist
      #     # => {#<Yt::Playlist @id=…> => 33.0, #<Yt::Playlist @id=…> => 12.0, …}
      #   @macro report_with_video_dimensions

      # @!macro [new] report_by_channel_dimensions
      #   @option options [Symbol] :by (:day) The dimension to collect $1 by.
      #     Accepted values are: +:day+, +:week+, +:month+, +:range+,
      #     +:traffic_source+, +:search_term+, +:playback_location+, +:video+,
      #     +:related_video+, +:playlist+, +:embedded_player_location+.
      #   @return [Hash<Symbol, $2>] if grouped by embedded player location,
      #     the $1 for each embedded player location.
      #   @example Get yesterday’s $1 by embedded player location:
      #     resource.$1 since: 1.day.ago, until: 1.day.ago, by: :embedded_player_location
      #     # => {"fullscreen.net" => 92.0, "yahoo.com" => 14.0, …}
      #   @macro report_with_channel_dimensions
      #   @macro report_with_country_and_state

      # @!macro [new] report_by_playlist_dimensions
      #   @option options [Symbol] :by (:day) The dimension to collect $1 by.
      #     Accepted values are: +:day+, +:week+, +:month+, +:range+,
      #     +:traffic_source+, +:playback_location+, +:related_video+, +:video+,
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

      # Defines a public instance methods to access the reports of a
      # resource for a specific metric.
      # @param [Symbol] metric the metric to access the reports of.
      # @param [Class] type The class to cast the returned values to.
      # @example Adds +comments+ on a Channel resource.
      #   class Channel < Resource
      #     has_report :comments, Integer
      #   end
      def has_report(metric, type)
        require 'yt/collections/reports'

        define_metric_method metric
        define_reports_method metric, type
        define_range_metric_method metric
        define_all_metric_method metric, type
      end

    private

      def define_reports_method(metric, type)
        (@metrics ||= {})[metric] = type
        define_method :reports do |options = {}|
          from = options[:since] || options[:from] || (options[:by].in?([:day, :week, :month]) ? 5.days.ago : '2005-02-01')
          to = options[:until] || options[:to] || Date.today
          location = options[:in]
          country = location.is_a?(Hash) ? location[:country] : location
          state = location[:state] if location.is_a?(Hash)
          dimension = options[:by] || (metric == :viewer_percentage ? :gender_age_group : :range)
          videos = options[:videos]
          if dimension == :month
            from = from.to_date.beginning_of_month
            to = to.to_date.beginning_of_month
          end
          date_range = Range.new *[from, to].map(&:to_date)

          only = options.fetch :only, []
          reports = Collections::Reports.of(self).tap do |reports|
            reports.metrics =  self.class.instance_variable_get(:@metrics).select{|k, v| k.in? only}
          end
          reports.within date_range, country, state, dimension, videos
        end unless defined?(reports)
      end

      def define_metric_method(metric)
        define_method metric do |options = {}|
          from = options[:since] || options[:from] || (options[:by].in?([:day, :week, :month]) ? 5.days.ago : '2005-02-01')
          to = options[:until] || options[:to] || Date.today
          location = options[:in]
          country = location.is_a?(Hash) ? location[:country] : location
          state = location[:state] if location.is_a?(Hash)
          dimension = options[:by] || (metric == :viewer_percentage ? :gender_age_group : :range)
          videos = options[:videos]
          if dimension == :month
            from = from.to_date.beginning_of_month
            to = to.to_date.beginning_of_month
          end
          range = Range.new *[from, to].map(&:to_date)

          ivar = instance_variable_get "@#{metric}_#{dimension}_#{country}_#{state}"
          instance_variable_set "@#{metric}_#{dimension}_#{country}_#{state}", ivar || {}
          results = case dimension
          when :day
            Hash[*range.flat_map do |date|
              [date, instance_variable_get("@#{metric}_#{dimension}_#{country}_#{state}")[date] ||= send("range_#{metric}", range, dimension, country, state, videos)[date]]
            end]
          else
            instance_variable_get("@#{metric}_#{dimension}_#{country}_#{state}")[range] ||= send("range_#{metric}", range, dimension, country, state, videos)
          end
          lookup_class = case options[:by]
            when :video, :related_video then Yt::Collections::Videos
            when :playlist then Yt::Collections::Playlists
          end
          if lookup_class
            includes = options.fetch(:includes, [:id]).join(',').camelize(:lower)
            items = lookup_class.new(auth: auth).where(part: includes, id: results.keys.join(','))
            results.transform_keys{|id| items.find{|item| item.id == id}}.reject{|k, _| k.nil?}
          else
            results
          end
        end
      end

      def define_range_metric_method(metric)
        define_method "range_#{metric}" do |date_range, dimension, country, state, videos|
          ivar = instance_variable_get "@range_#{metric}_#{dimension}_#{country}_#{state}"
          instance_variable_set "@range_#{metric}_#{dimension}_#{country}_#{state}", ivar || {}
          instance_variable_get("@range_#{metric}_#{dimension}_#{country}_#{state}")[date_range] ||= send("all_#{metric}").within date_range, country, state, dimension, videos
        end
        private "range_#{metric}"
      end

      def define_all_metric_method(metric, type)
        define_method "all_#{metric}" do
          # @note Asking for the "estimated_revenue" metric of a day in which a channel
          # made 0 USD returns the wrong "nil". But adding to the request the
          # "estimatedMinutesWatched" metric returns the correct value 0.
          metrics = {metric => type}
          metrics[:estimated_minutes_watched] = Integer if metric == :estimated_revenue
          Collections::Reports.of(self).tap{|reports| reports.metrics = metrics}
        end
        private "all_#{metric}"
      end
    end
  end
end