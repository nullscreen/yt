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
      regex? :video_long_url, :video_short_url
    end

    # Returns whether the description includes a YouTube channel URL
    #
    # @example
    #
    # description = Yt::Description.new Link to channel: youtube.com/fullscreen
    # description.has_link_to_channel? #=> true
    #
    # @return [Boolean] Whether the description includes a link to a channel
    def has_link_to_channel?(options = {}) # TODO: which channel
      # TODO: might take as an option WHICH channel to link to
      # in order to check if it's my own channel
      regex? :channel_long_url, :channel_short_url, :channel_user_url
    end

    # Returns whether the description includes a YouTube subscription URL
    #
    # @example
    #
    # description = Yt::Description.new Link to subscribe: youtube.com/subscription_center?add_user=fullscreen
    # description.has_link_to_subscribe? #=> true
    #
    # @return [Boolean] Whether the description includes a link to subscribe
    def has_link_to_subscribe?(options = {}) # TODO: which channel
      # TODO: might take as an option WHICH channel to subscribe to
      # in order to check if it's my own channel
      regex? :subscribe_center_url, :subscribe_widget_url, :subscribe_confirm_url
    end

    # Returns whether the description includes a YouTube playlist URL
    #
    # @example
    #
    # description = Yt::Description.new Link to playlist: youtube.com/playlist?list=LLxO1tY8h1AhOz0T4ENwmpow
    # description.has_link_to_playlist? #=> true
    #
    # @return [Boolean] Whether the description includes a link to a playlist
    def has_link_to_playlist?
      regex? :playlist_long_url, :playlist_embed_url
    end

  private

    def regex?(*keys)
      keys.find{|key| self =~ regex_for(key)}
    end

    def regex_for(key)
      host, name = '(?:https?://)?(?:www\.)?', '([a-zA-Z0-9_-]+)'
      case key
      when :video_long_url
        %r{#{host}youtube\.com/watch\?v=#{name}}
      when :video_short_url
        %r{#{host}youtu\.be/#{name}}
      when :channel_long_url
        %r{#{host}youtube\.com/channel/#{name}}
      when :channel_short_url
        %r{#{host}youtube\.com/#{name}}
      when :channel_user_url
        %r{#{host}youtube\.com/user/#{name}}
      when :subscribe_center_url
        %r{#{host}youtube\.com/subscription_center\?add_user=#{name}}
      when :subscribe_widget_url
        %r{#{host}youtube\.com/subscribe_widget\?p=#{name}}
      when :subscribe_confirm_url
        %r{#{host}youtube\.com/channel/(?:[a-zA-Z0-9&_=-]*)\?sub_confirmation=1}
      when :playlist_long_url
        %r{#{host}youtube\.com/playlist\?list=#{name}}
      when :playlist_embed_url
        %r{#{host}youtube\.com/watch\?v=(?:[a-zA-Z0-9&_=-]*)&list=#{name}}
      end
    end
  end
end