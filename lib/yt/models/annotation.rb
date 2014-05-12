module Yt
  # Provides methods to access and analyze a single YouTube annotation.
  class Annotation
    # Instantiate an Annotation object from its YouTube XML representation.
    #
    # @note There is no documented way to access annotations through API.
    #       There is an endpoint that returns an XML in an undocumented format,
    #       which is here parsed into a comprehensible set of attributes.
    #
    # @param [String] xml_data The YouTube XML representation of an annotation
    def initialize(options = {})
      @data = options[:data]
    end

    # Checks whether the entire annotation box remains above y
    #
    # @param [Integer] y Vertical position in the Youtube video (0 to 100)
    #
    # @return [Boolean] Whether the box remains above y
    def above?(y)
      top && top < y
    end

    # Checks whether the entire annotation box remains below y
    #
    # @param [Integer] y Vertical position in the Youtube video (0 to 100)
    #
    # @return [Boolean] Whether the box remains below y
    def below?(y)
      bottom && bottom > y
    end

    # Checks whether there is a link to subscribe.
    # Should a branding watermark also counts, because it links to the channel?
    #
    # @return [Boolean] Whether there is a link to subscribe in the annotation
    def has_link_to_subscribe?(options = {}) # TODO: options for which videos
      link_class == '5'
    end

    # Checks whether there is a link to a video.
    # An Invideo featured video also counts
    #
    # @return [Boolean] Whether there is a link to a video in the annotation
    def has_link_to_video?(options = {}) # TODO: options for which videos
      link_class == '1' || type == 'promotion'
    end

    # Checks whether there is a link to a playlist.
    # A link to a video with the playlist in the URL also counts
    #
    # @return [Boolean] Whether there is a link to a playlist in the annotation
    def has_link_to_playlist?
      link_class == '2' || text.include?('&list=')
    end

    # Checks whether the link opens in the same window.
    #
    # @return [Boolean] Whether the link opens in the same window
    def has_link_to_same_window?
      link_target == 'current'
    end

    # Checks whether the annotation comes from InVideo Programming
    #
    # @return [Boolean] Whether the annotation comes from InVideo Programming
    def has_invideo_programming?
      type == 'promotion' || type == 'branding'
    end

    # @return [Boolean] Whether the annotation starts after the number of seconds
    # @note This is broken for invideo programming, because they do not
    # have the timestamp in the region, but in the "data" field
    def starts_after?(seconds)
      timestamps.first > seconds if timestamps.any?
    end

    # @return [Boolean] Whether the annotation starts before the number of seconds
    # @note This is broken for invideo programming, because they do not
    # have the timestamp in the region, but in the "data" field
    def starts_before?(seconds)
      timestamps.first < seconds if timestamps.any?
    end

  private

    def text
      @text ||= @data.fetch 'TEXT', ''
    end

    def type
      @type ||= @data.fetch 'type', ''
    end

    def link_class
      @link_class ||= url['link_class']
    end

    def link_target
      @link_target ||= url['target']
    end

    def url
      @url ||= action.fetch 'url', {}
    end

    def action
      @action ||= @data.fetch 'action', {}
    end

    def top
      @top ||= positions.map{|pos| pos['y'].to_f}.max
    end

    def bottom
      @bottom ||= positions.map{|pos| pos['y'].to_f + pos['h'].to_f}.max
    end

    def timestamps
      @timestamps ||= positions.map do |pos|
        regex = %r{(?:|(?<hours>\d*):)(?:|(?<min>\d*):)(?<sec>\d*)\.(?<ms>\d*)}
        match = pos['t'].match regex
        hours = (match[:hours] || '0').to_i
        minutes = (match[:min] || '0').to_i
        seconds = (match[:sec]).to_i
        (hours * 60 + minutes) * 60 + seconds
      end
    end

    def positions
      @positions ||= region['rectRegion'] || region['anchoredRegion'] || []
    end

    def region
      @region ||= segment.fetch 'movingRegion', {}
    end

    def segment
      @segment ||= (@data['segment'] || {})
    end
  end
end