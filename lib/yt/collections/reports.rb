require 'yt/collections/base'

module Yt
  module Collections
    # @private
    class Reports < Base
      DIMENSIONS = Hash.new({name: 'day', parse: ->(day, *values) {[Date.iso8601(day), values.last]} }).tap do |hash|
        hash[:month] = {name: 'month', parse: ->(month, *values) { [Range.new(Date.strptime(month, '%Y-%m').beginning_of_month, Date.strptime(month, '%Y-%m').end_of_month), values.last]} }
        hash[:range] = {parse: ->(*values) { [:total, values.last]} }
        hash[:traffic_source] = {name: 'insightTrafficSourceType', parse: ->(source, value) {[TRAFFIC_SOURCES.key(source), value]} }
        hash[:playback_location] = {name: 'insightPlaybackLocationType', parse: ->(location, value) {[PLAYBACK_LOCATIONS.key(location), value]} }
        hash[:embedded_player_location] = {name: 'insightPlaybackLocationDetail', parse: ->(url, value) {[url, value]} }
        hash[:related_video] = {name: 'insightTrafficSourceDetail', parse: ->(video_id, value) { [Yt::Video.new(id: video_id, auth: @auth), value] } }
        hash[:search_term] = {name: 'insightTrafficSourceDetail', parse: ->(search_term, value) { [search_term, value] } }
        hash[:video] = {name: 'video', parse: ->(video_id, value) { [Yt::Video.new(id: video_id, auth: @auth), value] } }
        hash[:playlist] = {name: 'playlist', parse: ->(playlist_id, value) { [Yt::Playlist.new(id: playlist_id, auth: @auth), value] } }
        hash[:device_type] = {name: 'deviceType', parse: ->(type, value) { [type.downcase.to_sym, value] } }
        hash[:country] = {name: 'country', parse: ->(country_code, *values) { [country_code, values.last]  } }
        hash[:state] = {name: 'province', parse: ->(country_and_state_code, *values) { [country_and_state_code[3..-1], values.last]  } }
        hash[:gender_age_group] = {name: 'gender,ageGroup', parse: ->(gender, *values) { [gender.downcase.to_sym, *values] }}
        hash[:gender] = {name: 'gender', parse: ->(gender, value) { [gender.downcase.to_sym, value] } }
        hash[:age_group] = {name: 'ageGroup', parse: ->(age_group, value) { [age_group[3..-1], value] } }
      end

      # @see https://developers.google.com/youtube/analytics/v1/dimsmets/dims#Traffic_Source_Dimensions
      # @note EXT_APP is also returned but it’s not in the documentation above!
      TRAFFIC_SOURCES = {
        advertising: 'ADVERTISING',
        annotation: 'ANNOTATION',
        external_app: 'EXT_APP',
        external_url: 'EXT_URL',
        embedded: 'NO_LINK_EMBEDDED',
        other: 'NO_LINK_OTHER',
        playlist: 'PLAYLIST',
        promoted: 'PROMOTED',
        related_video: 'RELATED_VIDEO',
        subscriber: 'SUBSCRIBER',
        channel: 'YT_CHANNEL',
        other_page: 'YT_OTHER_PAGE',
        search: 'YT_SEARCH',
      }

      # @see https://developers.google.com/youtube/analytics/v1/dimsmets/dims#Playback_Location_Dimensions
      PLAYBACK_LOCATIONS = {
        channel: 'CHANNEL',
        watch: 'WATCH',
        embedded: 'EMBEDDED',
        other: 'YT_OTHER',
        external_app: 'EXTERNAL_APP',
        mobile: 'MOBILE' # only present for data < September 10, 2013
      }

      attr_writer :metric

      def within(days_range, country, state, dimension, type, try_again = true)
        @days_range = days_range
        @dimension = dimension
        @country = country
        @state = state
        if dimension == :gender_age_group # array of array
          Hash.new{|h,k| h[k] = Hash.new 0.0}.tap do |hash|
            each{|gender, age_group, value| hash[gender][age_group[3..-1]] = value}
          end
        else
          Hash[*flat_map{|value| [value.first, type_cast(value.last, type)]}]
        end
      # NOTE: Once in a while, YouTube responds with 400 Error and the message
      # "Invalid query. Query did not conform to the expectations."; in this
      # case running the same query after one second fixes the issue. This is
      # not documented by YouTube and hardly testable, but trying again the
      # same query is a workaround that works and can hardly cause any damage.
      # Similarly, once in while YouTube responds with a random 503 error.
      rescue Yt::Error => e
        try_again && rescue?(e) ? sleep(3) && within(days_range, country, state, dimension, type, false) : raise
      end

    private

      def type_cast(value, type)
        case [type]
          when [Integer] then value.to_i if value
          when [Float] then value.to_f if value
        end
      end

      def new_item(data)
        instance_exec *data, &DIMENSIONS[@dimension][:parse]
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
          params['dimensions'] = DIMENSIONS[@dimension][:name] unless @dimension == :range
          params['max-results'] = 10 if @dimension == :video
          params['max-results'] = 200 if @dimension == :playlist
          params['max-results'] = 25 if @dimension.in? [:embedded_player_location, :related_video, :search_term]
          params['sort'] = "-#{@metric.to_s.camelize(:lower)}" if @dimension.in? [:video, :playlist, :embedded_player_location, :related_video, :search_term]
          params[:filters] = ((params[:filters] || '').split(';') + ["country==US"]).compact.uniq.join(';') if @dimension == :state && !@state
          params[:filters] = ((params[:filters] || '').split(';') + ["country==#{@country}"]).compact.uniq.join(';') if @country && !@state
          params[:filters] = ((params[:filters] || '').split(';') + ["province==US-#{@state}"]).compact.uniq.join(';') if @state
          params[:filters] = ((params[:filters] || '').split(';') + ['isCurated==1']).compact.uniq.join(';') if @dimension == :playlist
          params[:filters] = ((params[:filters] || '').split(';') + ['insightPlaybackLocationType==EMBEDDED']).compact.uniq.join(';') if @dimension == :embedded_player_location
          params[:filters] = ((params[:filters] || '').split(';') + ['insightTrafficSourceType==RELATED_VIDEO']).compact.uniq.join(';') if @dimension == :related_video
          params[:filters] = ((params[:filters] || '').split(';') + ['insightTrafficSourceType==YT_SEARCH']).compact.uniq.join(';') if @dimension == :search_term
        end
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
