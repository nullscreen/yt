module Yt
  module Models
    # Provides methods to interact with YouTube annotations.
    # @note YouTube API V3 does not provide access to video annotations,
    #   therefore a legacy XML endpoint is used to retrieve annotations.
    # @see https://www.youtube.com/yt/playbook/annotations.html
    class Annotation < Base
      # @param [Hash] options the options to initialize an Annotation.
      # @option options [String] :data The XML representation of an annotation
      def initialize(options = {})
        @data = options[:data]
      end

      # @return [Boolean] whether the text box surrounding the annotation is
      #   completely in the top y% of the video frame.
      # @param [Integer] y Vertical position in the Youtube video (0 to 100)
      def above?(y)
        top && top < y
      end

      # @return [Boolean] whether the text box surrounding the annotation is
      #   completely in the bottom y% of the video frame.
      # @param [Integer] y Vertical position in the Youtube video (0 to 100)
      def below?(y)
        bottom && bottom > y
      end

      # @return [Boolean] whether the annotation includes a link to subscribe.
      def has_link_to_subscribe?(options = {}) # TODO: options for which videos
        link_class == '5'
      end

      # @return [Boolean] whether the annotation includes a link to a video,
      #   either directly in the text, or as an "Invideo featured video".
      def has_link_to_video?(options = {}) # TODO: options for which videos
        link_class == '1' || type == 'promotion'
      end

      # @return [Boolean] whether the annotation includes a link to a playlist,
      #   or to a video embedded in a playlist.
      def has_link_to_playlist?
        link_class == '2' || text.include?('&list=')
      end

      # @return [Boolean] whether the annotation includes a link that will
      #   open in the current browser window.
      def has_link_to_same_window?
        link_target == 'current'
      end

      # @return [Boolean] whether the annotation is an "InVideo Programming".
      def has_invideo_programming?
        type == 'promotion' || type == 'branding'
      end

      # @param [Numeric] seconds the number of seconds
      # @return [Boolean] whether the annotation starts after the number of
      #   seconds indicated.
      # @note This is broken for invideo programming, because they do not
      #   have the timestamp in the region, but in the "data" field
      def starts_after?(seconds)
        timestamps.first > seconds if timestamps.any?
      end

      # @param [Numeric] seconds the number of seconds
      # @return [Boolean] whether the annotation starts before the number of
      #   seconds indicated.
      # @note This is broken for invideo programming, because they do not
      #   have the timestamp in the region, but in the "data" field
      def starts_before?(seconds)
        timestamps.first < seconds if timestamps.any?
      end

      # @return [String] the textual content of the annotation.
      def text
        @text ||= @data['TEXT'] || ''
      end

    private

      has_attribute :type, default: ''

      def link_class
        @link_class ||= url['link_class']
      end

      def link_target
        @link_target ||= url['target']
      end

      def url
        @url ||= action.fetch 'url', {}
      end

      has_attribute :action, default: {}

      def top
        @top ||= positions.map{|pos| pos['y'].to_f}.max
      end

      def bottom
        @bottom ||= positions.map{|pos| pos['y'].to_f + pos['h'].to_f}.max
      end

      def timestamps
        @timestamps ||= positions.reject{|pos| pos['t'] == 'never'}.map do |pos|
          timestamp_of pos
        end
      end

      def timestamp_of(position)
        regex = %r{(?:|(?<hours>\d*):)(?:|(?<min>\d*):)(?<sec>\d*)\.(?<ms>\d*)}
        position['t'] = '00:00:00.000' if position['t'] == '0'
        match = position['t'].match regex
        hours = (match[:hours] || '0').to_i
        minutes = (match[:min] || '0').to_i
        seconds = (match[:sec]).to_i
        (hours * 60 + minutes) * 60 + seconds
      end

      def positions
        @positions ||= Array.wrap region['rectRegion'] || region['anchoredRegion']
      end

      def region
        @region ||= segment.fetch 'movingRegion', {}
      end

      has_attribute :segment, type: Hash
    end
  end
end