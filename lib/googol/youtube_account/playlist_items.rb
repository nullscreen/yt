module Googol
  # Separate module to group YoutubeAccount methods related to playlist items.
  module PlaylistItems
    # Add an item to a Youtube playlist.
    #
    # @param [String] playlist_id The ID of the playlist to add videos to
    # @param [Hash] target The item to add to the playlist
    # @option target [String] :video_id The ID of the item (when item is video)
    #
    # @note Google API allows other types of items to be added to a playlist
    #       but for now we are just using videos. If you need other types,
    #       we can just expand this method.
    #
    # @see https://developers.google.com/youtube/v3/docs/playlistItems/insert
    #
    def add_item_to!(playlist_id, item = {})
      resource = {videoId: fetch!(item, :video_id), kind: 'youtube#video'}
      youtube_request! method: :post, json: true,
        path: '/playlistItems?part=snippet',
        body: {snippet: {playlistId: playlist_id, resourceId: resource}}
    end

    # Remove all items from a Youtube playlist.
    #
    # @param [String] playlist_id The ID of the playlist to add videos to
    # @param [Hash] filters The filter to remove the playlist items by.
    #
    # @see https://developers.google.com/youtube/v3/docs/playlistItems/delete
    #
    def remove_all_items_from!(playlist_id, filters = {})
      items_of(playlist_id, filters).map do |item_id|
        remove_item_from! playlist_id, item_id
      end
    end

    # Adds an array of videos to a Youtube playlist.
    #
    # @param [String] playlist_id The ID of the playlist to add videos to
    # @param [Array of String] video_ids The IDs of the videos to add
    #
    # @see https://developers.google.com/youtube/v3/docs/playlistItems/insert
    #
    def add_videos_to!(playlist_id, video_ids = [])
      video_ids.map{|video_id| add_item_to! playlist_id, video_id: video_id}
    end

  private

    # List all items of a Youtube playlist.
    #
    # @param [String] playlist_id The ID of the playlist to add videos to
    #
    # @return [Array of Hashes] Items of the playlist
    #
    # @note Google API does not have a "search" endpoint, therefore we have
    # to scan the list of playlist items page by page, limiting at 10 pages to
    # prevent this function from running forever (50 items per page).
    #
    # @see https://developers.google.com/youtube/v3/docs/playlistItems/list
    #
    def items_of(playlist_id, filters = {})
      page = filters.delete(:page) || 1

      path = "/playlistItems?part=id,snippet&playlistId=#{playlist_id}"
      path << "&maxResults=#{filters.delete(:max) || 50 }"
      path << "&pageToken=#{filters.delete :token}" if filters[:token]

      response = youtube_request! path: path
      items = response[:items].map{|item| item[:id]}

      more_items = if page < 10 && token = response[:nextPageToken]
        items_of playlist_id, page: page + 1, token: token
      else
        []
      end

      items + more_items
    end

    # Remove an item from a playlist.
    #
    # @param [String] playlist_id The ID of the playlist to remove items from
    # @param [String] playlist_item_id The ID of the item to remove
    #
    # @see https://developers.google.com/youtube/v3/docs/playlistItems/delete
    #
    def remove_item_from!(playlist_id, item_id)
      youtube_request! method: :delete, code: 204,
        path: "/playlistItems?id=#{item_id}"
    end
  end
end