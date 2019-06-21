require 'yt/models/video'
require 'yt/models/playlist'
require 'yt/models/channel'

module Yt
  module Models
    # Provides methods to identify YouTube resources from names or URLs.
    # @see https://developers.google.com/youtube/v3/docs
    # @example Identify a YouTube video from its short URL:
    #   url = Yt::URL.new 'youtu.be/kawaiiguy'
    #   url.id # => 'UC4lU5YG9QDgs0X2jdnt7cdQ'
    #   url.resource # => #<Yt::Channel @id=UC4lU5YG9QDgs0X2jdnt7cdQ>
    class URL
      # @param [String] text the name or URL of a YouTube resource (in any form).
      def initialize(text)
        @text = text.to_s.strip
        @match = find_pattern_match
      end

      # @return [Symbol] the kind of YouTube resource matching the URL.
      # Possible values are: +:playlist+, +:video+, +:channel+, and +:unknown:.
      def kind
        @match[:kind]
      end

      # @return [<String, nil>] the ID of the YouTube resource matching the URL.
      def id
        @match['id'] ||= fetch_id
      end

      # @return [<Yt::Channel>] the resource associated with the URL
      def resource(options = {})
        @resource ||= case kind
          when :channel then Yt::Channel
          when :video then Yt::Video
          when :playlist then Yt::Playlist
          else raise Yt::Errors::NoItems
        end.new options.merge(id: id)
      end

      # @return [Array<Regexp>] patterns matching URLs of YouTube playlists.
      PLAYLIST_PATTERNS = [
         %r{^(?:https?://)?(?:www\.)?youtube\.com/playlist/?\?list=(?<id>[a-zA-Z0-9_-]+)},
      ]

      # @return [Array<Regexp>] patterns matching URLs of YouTube videos.
      VIDEO_PATTERNS = [
        %r{^(?:https?://)?(?:www\.)?youtube\.com/watch\?v=(?<id>[a-zA-Z0-9_-]{11})},
        %r{^(?:https?://)?(?:www\.)?youtu\.be/(?<id>[a-zA-Z0-9_-]{11})},
        %r{^(?:https?://)?(?:www\.)?youtube\.com/embed/(?<id>[a-zA-Z0-9_-]{11})},
        %r{^(?:https?://)?(?:www\.)?youtube\.com/v/(?<id>[a-zA-Z0-9_-]{11})},
      ]

      # @return [Array<Regexp>] patterns matching URLs of YouTube channels.
      CHANNEL_PATTERNS = [
        %r{^(?:https?://)?(?:www\.)?youtube\.com/channel/(?<id>UC[a-zA-Z0-9_-]{22})},
        %r{^(?:https?://)?(?:www\.)?youtube\.com/(?<format>c/|user/)?(?<name>[a-zA-Z0-9_-]+)}
      ]

    private

      def find_pattern_match
        patterns.find(-> {{kind: :unknown}}) do |kind, regex|
          if data = @text.match(regex)
            # Note: With Ruby 2.4, the following is data.named_captures
            break data.names.zip(data.captures).to_h.merge kind: kind
          end
        end
      end

      def patterns
        # @note: :channel *must* be the last since one of its regex eats the
        # remaining patterns. In short, don't change the following order.
        Enumerator.new do |patterns|
          VIDEO_PATTERNS.each {|regex| patterns << [:video, regex]}
          PLAYLIST_PATTERNS.each {|regex| patterns << [:playlist, regex]}
          CHANNEL_PATTERNS.each {|regex| patterns << [:channel, regex]}
        end
      end

      def fetch_id
        response = Net::HTTP.start 'www.youtube.com', 443, use_ssl: true do |http|
          http.request Net::HTTP::Get.new("/#{@match['format']}#{@match['name']}")
        end
        if response.is_a?(Net::HTTPRedirection)
          response = Net::HTTP.start 'www.youtube.com', 443, use_ssl: true do |http|
            http.request Net::HTTP::Get.new(response['location'])
          end
        end
        regex = %r{<meta itemprop="channelId" content="(?<id>UC[a-zA-Z0-9_-]{22})">}
        if data = response.body.match(regex)
          data[:id]
        else
          raise Yt::Errors::NoItems
        end
      end
    end
  end
end
