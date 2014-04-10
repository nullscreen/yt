require 'googol/authenticable'
require 'googol/readable'

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

    # Return the first playlist of the Youtube account matching the attributes.
    # If such a playlist is not found, it gets created and yielded to the block.
    #
    # @note Inspired by Ruby on Rails’ find_or_create_by
    #
    # @param [Hash] target The target of the 'add_to' activity
    # @option target [String] :video_id The ID of the video to add
    # @option target [String] :playlist_id The ID of the playlist to add to
    #
    # @see https://developers.google.com/youtube/v3/docs/playlistItems/insert
    #
    def find_or_create_playlist_by(attributes = {}, &block)
      find_playlist_by(attributes) || create_playlist!(attributes, &block)
    end

    # Adds a video to a playlist as a Youtube account
    #
    # @param [Hash] target The target of the 'add_to' activity
    # @option target [String] :video_id The ID of the video to add
    # @option target [String] :playlist_id The ID of the playlist to add to
    #
    # @see https://developers.google.com/youtube/v3/docs/playlistItems/insert
    #
    def add_to!(target = {})
      video_id, playlist_id = fetch! target, :video_id, :playlist_id
      resource = {videoId: video_id, kind: 'youtube#video'}
      youtube_request! method: :post, json: true,
        path: '/playlistItems?part=snippet',
        body: {snippet: {playlistId: playlist_id, resourceId: resource}}
    end

  private

    # Creates a playlist for a Youtube account and yield it to the block
    #
    # @param [Hash] attributes The attributes of the new playlist
    # @option attributes [String] :title Title of the playlist
    # @option attributes [String] :description Description of the playlist
    #
    # @return [String] The ID of the playlist
    #
    # @see https://developers.google.com/youtube/v3/docs/playlists/insert
    #
    def create_playlist!(attrs = {}, &block)
      snippet = {title: attrs[:title], description: attrs[:description]}
      playlist = youtube_request! json: true, method: :post,
        path: '/playlists?part=snippet,status',
        body: {snippet: snippet, status: {privacyStatus: :public}}
      yield playlist if block_given?
      playlist[:id]
    end

    # Return the first playlist of the Youtube account matching the attributes.
    #
    # @param [Hash] filters The filter to query the list of playlists with.
    # @option title [String or Regex] Filter on the title
    # @option description [String or Regex] Filter on the description
    #
    # @example account.find_playlist_by title: 'Title' # => 'e45fXDsdsdsd'
    # @example account.find_playlist_by description: 'xxxx' # => nil
    #
    # @note Google API does not have a "search" endpoint, therefore we have
    # to scan the list of playlist page by page, limiting at 10 pages to
    # prevent this function from running forever (50 playlists per page).
    #
    # @return [String or nil] The ID of the playlist (or nil if not found)
    def find_playlist_by(filters = {})
      page = filters.delete(:page) || 1

      path = "/playlists?part=id,snippet&mine=true"
      path << "&maxResults=#{filters.delete(:max) || 50 }"
      path << "&pageToken=#{filters.delete :token}" if filters[:token]

      response = youtube_request! path: path

      if playlist = response[:items].find{|p| playlist_matches? p, filters}
        playlist[:id]
      elsif page < 10 && token = response[:nextPageToken]
        find_playlist_by filters.merge page: page, token: token
      end
    end

    # Checks if the playlist matches the given filters.
    #
    # @param [Hash] filters The filter to query the list of playlists with.
    # @option title [String or Regex] Filter on the title
    # @option description [String or Regex] Filter on the description
    #
    # @note String filters match when they are included in the specified field
    #       Regex filters match when they match as a Regex against the field
    #
    # @example Given a playlist x with title: 'A title', description: 'Example'
    #     playlist_matches? x, title: 'tit' # => true
    #     playlist_matches? x, title: 'TIT' # => false
    #     playlist_matches? x, title: /^TIT/i # => true
    #     playlist_matches? x, title: /^TIT/i, description: 'Ex' # => true
    #     playlist_matches? x, title: /^TIT/i, description: 'xxx' # => false
    #
    # @return [Boolean] Whether the playlist matches the filters
    def playlist_matches?(playlist, filters = {})
      filters.all? do |attribute, string_or_regex|
        playlist[:snippet].fetch(attribute, '')[string_or_regex]
      end
    end

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