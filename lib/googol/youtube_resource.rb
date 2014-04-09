require 'googol/requestable'
require 'googol/readable'
require 'googol/server_tokens'

module Googol
  # Provides read-only access to a Youtube resource (a channel or a video).
  #
  # @example Get the description of the video "Tongue" by R.E.M.:
  #
  #       resource = Googol::YoutubeResource.new url: 'youtu.be/Kd5M17e7Wek'
  #       resource.description # => "© 2006 WMG\nTongue (Video)"
  #
  # @example Get the description of the R.E.M. channel:
  #
  #       resource = Googol::YoutubeResource.new url: 'youtube.com/remhq'
  #       resource.description # => "R.E.M.'s Official YouTube Channel"
  #
  # Note that this class does not require the user to authenticate.
  #
  class YoutubeResource
    include Requestable
    include Readable
    include ServerTokens
    # Initialize a resource by URL
    #
    # @param [Hash] attrs
    # @option attrs [String] :url The URL of the Youtube channel or video
    def initialize(attrs = {})
      @url = attrs[:url]
    end

    # Return the profile info of a Youtube account/channel.
    #
    # @see https://developers.google.com/youtube/v3/docs/channels#resource
    #
    # @return [Hash]
    #   * :id [String] The ID that YouTube uses to uniquely identify the channel.
    #   * :etag [String] The Etag of this resource.
    #   * :kind [String] The value will be youtube#channel.
    #   * :snippet [Hash]
    #     - :title [String] The channel's title.
    #     - :description [String] The channel's description.
    #     - :publishedAt [String] The date and time that the channel was created. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
    #     - :thumbnails [Hash]
    #       + :default [Hash] Default thumbnail URL (88px x 88px)
    #       + :medium [Hash] Medium thumbnail URL (88px x 88px)
    #       + :high [Hash] High thumbnail URL (88px x 88px)
    def info
      @info ||= request! method: :get,
        host: 'https://www.googleapis.com',
        path: "/youtube/v3/#{info_path}",
        valid_if: -> resp, body {resp.code == '200' && body['items'].any?},
        extract: -> body {body['items'].first}
    end

  private

    ##
    # Return the path to execute the Google API request again.
    # Channels and videos have different paths, so it depends on the type
    #
    # @return [String] Path
    def info_path
      @info_path ||= case @url
        when regex?(:video_id) then "videos?id=#{$1}"
        when regex?(:video_short_id) then "videos?id=#{$1}"
        when regex?(:channel_id) then "channels?id=#{$1}"
        when regex?(:channel_username) then "channels?forUsername=#{$1}"
        when regex?(:channel_name) then "channels?forUsername=#{$1}"
        else raise RequestError, "Invalid Youtube URL: #{@url}"
      end + "&part=id,snippet&key=#{server_key}"
    end

    # Parses a URL to find the type and identifier of a Youtube resource
    def regex?(key)
      host, name = '^(?:https?://)?(?:www\.)?', '([a-zA-Z0-9_-]+)'
      case key
        when :video_id then %r{#{host}youtube\.com/watch\?v=#{name}}
        when :video_short_id then %r{#{host}youtu\.be/#{name}}
        when :channel_id then %r{#{host}youtube\.com/channel/#{name}}
        when :channel_username then %r{#{host}youtube\.com/user/#{name}}
        when :channel_name then %r{#{host}youtube\.com/#{name}}
      end
    end
  end
end