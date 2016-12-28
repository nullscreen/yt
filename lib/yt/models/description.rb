require 'yt/models/url'

module Yt
  module Models
    # Encapsulates information about the description of a resource, for
    # instance a channel.
    # @see https://developers.google.com/youtube/v3/docs/channels#resource
    #
    # The value has a maximum length of 1000 characters.
    class Description < String
      # @return [Boolean] whether the description includes a link to a video
      # @example
      #   description = Yt::Models::Description.new 'Link to video: youtube.com/watch?v=9bZkp7q19f0'
      #   description.has_link_to_video? #=> true
      #
      # @todo add an option to match the link to a specific video
      def has_link_to_video?
        links.any?{|link| link.kind == :video}
      end

      # @return [Boolean] whether the description includes a link to a channel
      # @example
      #   description = Yt::Description.new 'Link to channel: youtube.com/fullscreen'
      #   description.has_link_to_channel? #=> true
      #
      # @todo add an option to match the link to a specific channel
      def has_link_to_channel?(options = {})
        links.any?{|link| link.kind == :channel}
      end

      # @return [Boolean] whether the description includes a link to subscribe
      # @example
      #   description = Yt::Description.new 'Link to subscribe: youtube.com/subscription_center?add_user=fullscreen'
      #   description.has_link_to_subscribe? #=> true
      #
      # @todo add an option to match the link to subscribe to a specific channel
      def has_link_to_subscribe?(options = {})
        links.any?{|link| link.kind == :subscription}
      end

      # @return [Boolean] whether the description includes a link to a playlist
      # @example
      #   description = Yt::Description.new 'Link to playlist: youtube.com/playlist?list=LLxO1tY8h1AhOz0T4ENwmpow'
      #   description.has_link_to_playlist? #=> true
      #
      # @todo add an option to match the link to a specific playlist
      def has_link_to_playlist?
        links.any?{|link| link.kind == :playlist}
      end

    private

      def links
        @links ||= self.split(' ').map{|word| URL.new word}
      end
    end
  end
end