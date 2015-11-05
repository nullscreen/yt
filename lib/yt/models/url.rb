module Yt
  module Models
    # @private
    class URL
      attr_reader :kind

      def initialize(url)
        @url = url
        @kind ||= parse url
        @match_data ||= {}
      end

      def id
        @match_data[:id]
      rescue IndexError
      end

      def username
        @match_data[:username]
      rescue IndexError
      end

    private

      def parse(url)
        matching_pattern = patterns.find do |pattern|
          @match_data = url.match pattern[:regex]
        end
        matching_pattern[:kind] if matching_pattern
      end

      def patterns
        # @note: :channel *must* be the last since one of its regex eats the
        # remaining patterns. In short, don't change the following order

        @patterns ||= patterns_for :playlist, :subscription, :video, :channel
      end

      def patterns_for(*kinds)
        prefix = '^(?:https?://)?(?:www\.)?'
        suffix = '(?:|/)'
        kinds.map do |kind|
          patterns = send "#{kind}_patterns" # meta programming :/
          patterns.map do |pattern|
            {kind: kind, regex: %r{#{prefix}#{pattern}#{suffix}}}
          end
        end.flatten
      end

      def subscription_patterns
        name = '(?:[a-zA-Z0-9&_=-]*)'

        %W{
          subscription_center\\?add_user=#{name}
          subscribe_widget\\?p=#{name}
          channel/#{name}\\?sub_confirmation=1
        }.map{|path| "youtube\\.com/#{path}"}
      end

      def playlist_patterns
        playlist_id = '(?<id>[a-zA-Z0-9_-]+)'

        %W{
          playlist\\?list=#{playlist_id}
        }.map{|path| "youtube\\.com/#{path}"}
      end

      def video_patterns
        video_id = '(?<id>[a-zA-Z0-9_-]+)'

        %W{
          youtube\\.com/watch\\?v=#{video_id}
          youtu\\.be/#{video_id}
          youtube\\.com/embed/#{video_id}
          youtube\\.com/v/#{video_id}
        }
      end

      def channel_patterns
        channel_id = '(?<id>[a-zA-Z0-9_-]+)'
        username = '(?<username>[a-zA-Z0-9_-]+)'

        %W{
          channel/#{channel_id}
          user/#{username}
          #{username}
        }.map{|path| "youtube\\.com/#{path}"}
      end
    end
  end
end
