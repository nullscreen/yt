module Googol
  # Separate module to group YoutubeAccount methods related to playlists.
  module Playlists
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

    # Deletes a playlist of a Youtube account.
    #
    # @param [String] playlist_id The ID of the playlist to delete
    #
    # @see https://developers.google.com/youtube/v3/docs/playlists/delete
    #
    def delete_playlist!(playlist_id)
      youtube_request! method: :delete, code: 204,
        path: "/playlists?id=#{playlist_id}"
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
  end
end