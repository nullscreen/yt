require 'yt/models/url'

module Yt
  # Provides read-only access to the description of a YouTube resource.
  # Resources with descriptions are: videos and channels.
  #
  # @example
  #
  # description = Yt::Description.new 'Fullscreen provides a suite of end-to-end YouTube tools and services to many of the world’s leading brands and media companies.'
  # description.to_s.slice(0,19) # => 'Fullscreen provides'
  # description.length # => 127
  #
  class Description < String
    # Returns whether the description includes a YouTube video URL
    #
    # @example
    #
    # description = Yt::Description.new 'Link to video: youtube.com/watch?v=MESycYJytkU'
    # description.has_link_to_video? #=> true
    #
    # @return [Boolean] Whether the description includes a link to a video
    def has_link_to_video?
      # TODO: might take as an option WHICH video to link to
      # in order to check if it's my own video
      links.any?{|link| link.kind == :video}
    end

    # Returns whether the description includes a YouTube channel URL
    #
    # @example
    #
    # description = Yt::Description.new 'Link to channel: youtube.com/fullscreen'
    # description.has_link_to_channel? #=> true
    #
    # @return [Boolean] Whether the description includes a link to a channel
    def has_link_to_channel?(options = {}) # TODO: which channel
      # TODO: might take as an option WHICH channel to link to
      # in order to check if it's my own channel
      links.any?{|link| link.kind == :channel}
    end

    # Returns whether the description includes a YouTube subscription URL
    #
    # @example
    #
    # description = Yt::Description.new 'Link to subscribe: youtube.com/subscription_center?add_user=fullscreen'
    # description.has_link_to_subscribe? #=> true
    #
    # @return [Boolean] Whether the description includes a link to subscribe
    def has_link_to_subscribe?(options = {}) # TODO: which channel
      # TODO: might take as an option WHICH channel to subscribe to
      # in order to check if it's my own channel
      links.any?{|link| link.kind == :subscription}
    end

    # Returns whether the description includes a YouTube playlist URL
    #
    # @example
    #
    # description = Yt::Description.new 'Link to playlist: youtube.com/playlist?list=LLxO1tY8h1AhOz0T4ENwmpow'
    # description.has_link_to_playlist? #=> true
    #
    # @return [Boolean] Whether the description includes a link to a playlist
    def has_link_to_playlist?
      links.any?{|link| link.kind == :playlist}
    end

  private

    def links
      @links ||= self.split(' ').map{|word| URL.new word}
    end
  end
end