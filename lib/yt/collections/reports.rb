require 'yt/collections/base'

module Yt
  module Collections
    # @private
    class Reports < Base
      DIMENSIONS = Hash.new({name: 'day', parse: ->(day, *values) { @metrics.keys.zip(values.map{|v| {Date.iso8601(day) => v}}).to_h} }).tap do |hash|
        hash[:month] = {name: 'month', parse: ->(month, *values) { @metrics.keys.zip(values.map{|v| {Range.new(Date.strptime(month, '%Y-%m').beginning_of_month, Date.strptime(month, '%Y-%m').end_of_month) => v} }).to_h} }
        hash[:range] = {parse: ->(*values) { @metrics.keys.zip(values.map{|v| {total: v}}).to_h } }
        hash[:traffic_source] = {name: 'insightTrafficSourceType', parse: ->(source, *values) { @metrics.keys.zip(values.map{|v| {TRAFFIC_SOURCES.key(source) => v}}).to_h} }
        hash[:playback_location] = {name: 'insightPlaybackLocationType', parse: ->(location, *values) { @metrics.keys.zip(values.map{|v| {PLAYBACK_LOCATIONS.key(location) => v}}).to_h} }
        hash[:embedded_player_location] = {name: 'insightPlaybackLocationDetail', parse: ->(url, *values) {@metrics.keys.zip(values.map{|v| {url => v}}).to_h} }
        hash[:subscribed_status] = {name: 'subscribedStatus', parse: ->(status, *values) {@metrics.keys.zip(values.map{|v| {SUBSCRIBED_STATUSES.key(status) => v}}).to_h} }
        hash[:related_video] = {name: 'insightTrafficSourceDetail', parse: ->(video_id, *values) { @metrics.keys.zip(values.map{|v| {video_id => v}}).to_h} }
        hash[:search_term] = {name: 'insightTrafficSourceDetail', parse: ->(search_term, *values) {@metrics.keys.zip(values.map{|v| {search_term => v}}).to_h} }
        hash[:referrer] = {name: 'insightTrafficSourceDetail', parse: ->(url, *values) {@metrics.keys.zip(values.map{|v| {url => v}}).to_h} }
        hash[:video] = {name: 'video', parse: ->(video_id, *values) { @metrics.keys.zip(values.map{|v| {video_id => v}}).to_h} }
        hash[:playlist] = {name: 'playlist', parse: ->(playlist_id, *values) { @metrics.keys.zip(values.map{|v| {playlist_id => v}}).to_h} }
        hash[:device_type] = {name: 'deviceType', parse: ->(type, *values) {@metrics.keys.zip(values.map{|v| {DEVICE_TYPES.key(type) => v}}).to_h} }
        hash[:operating_system] = {name: 'operatingSystem', parse: ->(os, *values) {@metrics.keys.zip(values.map{|v| {OPERATING_SYSTEMS.key(os) => v}}).to_h} }
        hash[:youtube_product] = {name: 'youtubeProduct', parse: ->(product, *values) {@metrics.keys.zip(values.map{|v| {YOUTUBE_PRODUCTS.key(product) => v}}).to_h} }
        hash[:country] = {name: 'country', parse: ->(country_code, *values) { @metrics.keys.zip(values.map{|v| {country_code => v}}).to_h} }
        hash[:state] = {name: 'province', parse: ->(country_and_state_code, *values) { @metrics.keys.zip(values.map{|v| {country_and_state_code[3..-1] => v}}).to_h} }
        hash[:gender_age_group] = {name: 'gender,ageGroup', parse: ->(gender, *values) { [gender.downcase.to_sym, *values] }}
        hash[:gender] = {name: 'gender', parse: ->(gender, *values) {@metrics.keys.zip(values.map{|v| {gender.downcase.to_sym => v}}).to_h} }
        hash[:age_group] = {name: 'ageGroup', parse: ->(age_group, *values) {@metrics.keys.zip(values.map{|v| {age_group[3..-1] => v}}).to_h} }
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
        google: 'GOOGLE_SEARCH',
        notification: 'NOTIFICATION',
        playlist_page: 'YT_PLAYLIST_PAGE',
        campaign_card: 'CAMPAIGN_CARD',
        end_screen: 'END_SCREEN',
        info_card: 'INFO_CARD',
        hashtags: 'HASHTAGS',
        live_redirect: 'LIVE_REDIRECT',
        product_page: 'PRODUCT_PAGE',
        shorts: 'SHORTS',
        sound_page: 'SOUND_PAGE',
        video_remixes: 'VIDEO_REMIXES',
        immersive_live: 'IMMERSIVE_LIVE',
        shorts_content_links: 'SHORTS_CONTENT_LINKS'
      }

      # @see https://developers.google.com/youtube/analytics/dimensions#Playback_Location_Dimensions
      PLAYBACK_LOCATIONS = {
        channel: 'CHANNEL',
        watch: 'WATCH',
        embedded: 'EMBEDDED',
        other: 'YT_OTHER',
        external_app: 'EXTERNAL_APP',
        search: 'SEARCH',
        browse: 'BROWSE',
        mobile: 'MOBILE', # only present for data < September 10, 2013
        shorts_feed: 'SHORTS_FEED' # undocumented but returned by the API
      }

      # @see https://developers.google.com/youtube/analytics/v1/dimsmets/dims#Playback_Detail_Dimensions
      SUBSCRIBED_STATUSES = {
        subscribed: 'SUBSCRIBED',
        unsubscribed: 'UNSUBSCRIBED'
      }

      # @see https://developers.google.com/youtube/analytics/v1/dimsmets/dims#youtubeProduct
      YOUTUBE_PRODUCTS = {
        core: 'CORE',
        gaming: 'GAMING',
        kids: 'KIDS',
        unknown: 'UNKNOWN'
      }

      # @see https://developers.google.com/youtube/analytics/v1/dimsmets/dims#Device_Dimensions
      DEVICE_TYPES = {
        desktop: 'DESKTOP',
        game_console: 'GAME_CONSOLE',
        mobile: 'MOBILE',
        tablet: 'TABLET',
        tv: 'TV',
        unknown_platform: 'UNKNOWN_PLATFORM'
      }

      # @see https://developers.google.com/youtube/analytics/v1/dimsmets/dims#Device_Dimensions
      OPERATING_SYSTEMS = {
        android: 'ANDROID',
        bada: 'BADA',
        blackberry: 'BLACKBERRY',
        chromecast: 'CHROMECAST',
        docomo: 'DOCOMO',
        firefox: 'FIREFOX',
        hiptop: 'HIPTOP',
        ios: 'IOS',
        linux: 'LINUX',
        macintosh: 'MACINTOSH',
        meego: 'MEEGO',
        nintendo_3ds: 'NINTENDO_3DS',
        other: 'OTHER',
        playstation: 'PLAYSTATION',
        playstation_vita: 'PLAYSTATION_VITA',
        realmedia: 'REALMEDIA',
        smart_tv: 'SMART_TV',
        symbian: 'SYMBIAN',
        tizen: 'TIZEN',
        webos: 'WEBOS',
        wii: 'WII',
        windows: 'WINDOWS',
        windows_mobile: 'WINDOWS_MOBILE',
        xbox: 'XBOX',
        kaios: 'KAIOS'
      }

      attr_writer :metrics

      def within(days_range, country, state, dimension, videos, historical, max_retries = 3)
        @days_range = days_range
        @country = country
        @state = state
        @dimension = dimension
        @videos = videos
        @historical = historical
        if dimension == :gender_age_group # array of array
          Hash.new{|h,k| h[k] = Hash.new 0.0}.tap do |hash|
            each{|gender, age_group, value| hash[gender][age_group[3..-1]] = value}
          end
        else
          hash = flat_map do |hashes|
            hashes.map do |metric, values|
              [metric, values.transform_values{|v| type_cast(v, @metrics[metric])}]
            end.to_h
          end
          hash = hash.inject(@metrics.transform_values{|v| {}}) do |result, hash|
            result.deep_merge hash
          end
          if dimension == :month
            hash = hash.transform_values{|h| h.sort_by{|range, v| range.first}.to_h}
          elsif dimension == :day
            hash = hash.transform_values{|h| h.sort_by{|day, v| day}.to_h}
          elsif dimension.in? [:traffic_source, :country, :state, :playback_location, :device_type, :operating_system, :subscribed_status]
            hash = hash.transform_values{|h| h.sort_by{|range, v| -v}.to_h}
          end
          (@metrics.one? || @metrics.keys == [:estimated_revenue, :estimated_minutes_watched]) ? hash[@metrics.keys.first] : hash
        end
      # NOTE: Once in a while, YouTube responds with 400 Error and the message
      # "Invalid query. Query did not conform to the expectations."; in this
      # case running the same query after one second fixes the issue. This is
      # not documented by YouTube and hardly testable, but trying again the
      # same query is a workaround that works and can hardly cause any damage.
      # Similarly, once in while YouTube responds with a random 503 error.
      rescue Yt::Error => e
        (max_retries > 0) && rescue?(e) ? sleep(retry_time) && within(days_range, country, state, dimension, videos, historical, max_retries - 1) : raise
      end

    private

      def retry_time
        3
      end

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
          params[:host] = 'youtubeanalytics.googleapis.com'
          params[:path] = '/v2/reports'
          params[:params] = reports_params
          params[:camelize_params] = false
        end
      end

      def reports_params
        @parent.reports_params.tap do |params|
          params['startDate'] = @days_range.begin
          params['endDate'] = @days_range.end
          params['metrics'] = @metrics.keys.join(',').to_s.camelize(:lower)
          params['dimensions'] = DIMENSIONS[@dimension][:name] unless @dimension == :range
          params['includeHistoricalChannelData'] = @historical if @historical
          params['maxResults'] = 50 if @dimension.in? [:playlist, :video]
          params['maxResults'] = 25 if @dimension.in? [:embedded_player_location, :related_video, :search_term, :referrer]
          if @dimension.in? [:video, :playlist, :embedded_player_location, :related_video, :search_term, :referrer]
            if @metrics.keys == [:estimated_revenue, :estimated_minutes_watched]
              params['sort'] = '-estimatedRevenue'
            else
              params['sort'] = "-#{@metrics.keys.join(',').to_s.camelize(:lower)}"
            end
          end
          params[:filters] = "video==#{@videos.join ','}" if @videos
          params[:filters] = ((params[:filters] || '').split(';') + ["country==US"]).compact.uniq.join(';') if @dimension == :state && !@state
          params[:filters] = ((params[:filters] || '').split(';') + ["country==#{@country}"]).compact.uniq.join(';') if @country && !@state
          params[:filters] = ((params[:filters] || '').split(';') + ["province==US-#{@state}"]).compact.uniq.join(';') if @state
          params[:filters] = ((params[:filters] || '').split(';') + ['insightPlaybackLocationType==EMBEDDED']).compact.uniq.join(';') if @dimension == :embedded_player_location
          params[:filters] = ((params[:filters] || '').split(';') + ['insightTrafficSourceType==RELATED_VIDEO']).compact.uniq.join(';') if @dimension == :related_video
          params[:filters] = ((params[:filters] || '').split(';') + ['insightTrafficSourceType==YT_SEARCH']).compact.uniq.join(';') if @dimension == :search_term
          params[:filters] = ((params[:filters] || '').split(';') + ['insightTrafficSourceType==EXT_URL']).compact.uniq.join(';') if @dimension == :referrer
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
