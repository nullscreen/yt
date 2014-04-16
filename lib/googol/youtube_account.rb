require 'googol/authenticable'
require 'googol/readable'
require 'googol/youtube_account/playlists'

module Googol
  # Provides read & write access to a Youtube account (also known as Channel).
  #
  # @example Like the video "Tongue" by R.E.M. as a specific Youtube account:
  #   * Set up two pages: one with a link to authenticate, one to redirect to
  #   * In the first page, add a link to the authentication page:
  #
  #       Googol::YoutubeAccount.oauth_url(redirect_url)
  #
  #   * The user authenticates and lands on the second page, with an extra +code+ query parameter
  #   * Use the authorization code to initialize the YoutubeAccount and like the video:
  #
  #       account = Googol::YoutubeAccount.new code: code, redirect_url: redirect_url
  #       account.like! video_id: 'Kd5M17e7Wek' # => likes the video
  #
  class YoutubeAccount
    include Authenticable
    include Readable
    include Playlists
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
      @info_response ||= youtube_request! path: '/channels?part=id,snippet&mine=true'
      @info_response[:items].first
    end

    # Like a video as a Youtube account
    #
    # @param [Hash] target The target of the 'like' activity
    # @option target [String] :video_id The ID of the video to like
    #
    # @see https://developers.google.com/youtube/v3/docs/videos/rate
    #
    # @note Liking a video does not also subscribe to its channel
    #
    def like!(target = {})
      video_id = fetch! target, :video_id
      path = "/videos/rate?rating=like&id=#{video_id}"
      youtube_request! path: path, method: :post, code: 204
    end

    # Subscribe a Youtube account to a channel
    #
    # @param [Hash] target The target of the 'subscribe' activity
    # @option target [String] :channel_id The ID of the channel to subscribe to
    #
    # @see https://developers.google.com/youtube/v3/docs/subscriptions/insert
    #
    def subscribe_to!(target = {})
      channel_id = fetch! target, :channel_id
      youtube_request! path: '/subscriptions?part=snippet', json: true,
        method: :post, body: {snippet: {resourceId: {channelId: channel_id}}}
    rescue Googol::RequestError => e
      raise e unless e.to_s =~ /subscriptionDuplicate/
    end

  private

    # Fetch keys from a hash, raising a custom exception when not found
    def fetch!(hash, *keys)
      values = keys.map do |key|
        hash.fetch(key) {raise RequestError, "Missing #{key} in #{hash}"}
      end
      keys.one? ? values.first : values
    end

    # Overrides the super.request! with Youtube-specific params
    def youtube_request!(params = {})
      params[:path] = "/youtube/v3#{params[:path]}"
      params[:auth] = credentials[:access_token]
      params[:host] = 'https://www.googleapis.com'
      request! params
    end

    # Set the scopes to grant access to Youtube account
    #
    # @see https://developers.google.com/youtube/v3/guides/authentication
    def self.oauth_scopes
      %w(https://www.googleapis.com/auth/youtube)
    end
  end
end