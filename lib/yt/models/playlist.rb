require 'yt/models/resource'

module Yt
  module Models
    # Provides methods to interact with YouTube playlists.
    # @see https://developers.google.com/youtube/v3/docs/playlists
    class Playlist < Resource
      delegate :tags, :channel_id, :channel_title, to: :snippet

      # @!attribute [r] playlist_items
      #   @return [Yt::Collections::PlaylistItems] the playlist’s items.
      has_many :playlist_items

      # @macro has_report
      has_report :playlist_starts

      # Deletes the playlist.
      #
      # This method requires {Resource#auth auth} to return an authenticated
      # instance of {Yt::Account} with permissions to delete the playlist.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an account with permissions to delete the playlist.
      # @return [Boolean] whether the playlist does not exist anymore.
      def delete(options = {})
        do_delete {@id = nil}
        !exists?
      end

      def exists?
        !@id.nil?
      end

      # Adds a video to the playlist
      # Does not raise an error if the video cannot be added (e.g., unknown).
      #
      # This method requires {Resource#auth auth} to return an authenticated
      # instance of {Yt::Account} with permissions to update the playlist.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an account with permissions to update the playlist.
      # @return [Yt::PlaylistItem] the item added to the playlist.
      def add_video(video_id, attributes = {})
        playlist_item_params = playlist_item_params(video_id, attributes)
        playlist_items.insert playlist_item_params, ignore_errors: true
      end

      def add_video!(video_id, attributes = {})
        playlist_item_params = playlist_item_params(video_id, attributes)
        playlist_items.insert playlist_item_params
      end

      def add_videos(video_ids = [], attributes = {})
        video_ids.map{|video_id| add_video video_id, attributes}
      end

      def add_videos!(video_ids = [], attributes = {})
        video_ids.map{|video_id| add_video! video_id, attributes}
      end

      def delete_playlist_items(attrs = {})
        playlist_items.delete_all attrs
      end

      # @private
      # Tells `has_reports` to retrieve the reports from YouTube Analytics API
      # either as a Channel or as a Content Owner.
      # @see https://developers.google.com/youtube/analytics/v1/reports
      def reports_params
        {}.tap do |params|
          if auth.owner_name
            params[:ids] = "contentOwner==#{auth.owner_name}"
          else
            params[:ids] = "channel==#{channel_id}"
          end
          params[:filters] = "playlist==#{id};isCurated==1"
        end
      end

    private

      # @see https://developers.google.com/youtube/v3/docs/playlists/update
      def update_parts
        keys = [:title, :description, :tags]
        snippet = {keys: keys, required: true, sanitize_brackets: true}
        status = {keys: [:privacy_status]}
        {snippet: snippet, status: status}
      end

      # @todo: extend camelize to also camelize the nested hashes, so we
      #   don’t have to write videoId
      def playlist_item_params(video_id, params = {})
        params.dup.tap do |params|
          params[:resource_id] ||= {kind: 'youtube#video', videoId: video_id}
        end
      end
    end
  end
end