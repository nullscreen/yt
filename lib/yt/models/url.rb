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
      end

      # @return [Symbol] the kind of YouTube resource matching the URL.
      # Possible values are: +:playlist+, +:video+, +:channel+, and +:unknown:.
      def kind
        Resource.new(url: @text).kind.to_sym
      end

      # @return [<String, nil>] the ID of the YouTube resource matching the URL.
      def id
        Resource.new(url: @text).id
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
    end
  end
end
