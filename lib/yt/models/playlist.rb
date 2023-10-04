require 'yt/models/resource'

module Yt
  module Models
    # Provides methods to interact with YouTube playlists.
    # @see https://developers.google.com/youtube/v3/docs/playlists
    class Playlist < Resource

    ### SNIPPET ###

      # @!attribute [r] title
      #   @return [String] the playlist’s title.
      delegate :title, to: :snippet

      # @!attribute [r] description
      #   @return [String] the playlist’s description.
      delegate :description, to: :snippet

      # @!method thumbnail_url(size = :default)
      #   Returns the URL of the playlist’s thumbnail.
      #   @param [Symbol, String] size The size of the playlist’s thumbnail.
      #   @return [String] if +size+ is +default+, the URL of a 120x90px image.
      #   @return [String] if +size+ is +medium+, the URL of a 320x180px image.
      #   @return [String] if +size+ is +high+, the URL of a 480x360px image.
      #   @return [nil] if the +size+ is not +default+, +medium+ or +high+.
      delegate :thumbnail_url, to: :snippet

      # @!attribute [r] published_at
      #   @return [Time] the date and time that the playlist was created.
      delegate :published_at, to: :snippet

      # @!attribute [r] channel_id
      #   @return [String] the ID of the channel that the playlist belongs to.
      delegate :channel_id, to: :snippet

      # @!attribute [r] channel_title
      #   @return [String] the title of the channel that the playlist belongs to.
      delegate :channel_title, to: :snippet

    ### STATISTICS ###

      has_one :content_detail

      # @!attribute [r] item_count
      #   @return [Integer] the number of items in the playlist.
      delegate :item_count, to: :content_detail

    ### ACTIONS (UPLOAD, UPDATE, DELETE) ###

      # Deletes the playlist.
      # @return [Boolean] whether the playlist does not exist anymore.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} is not an
      #   authenticated Yt::Account with permissions to delete the playlist.
      def delete(options = {})
        do_delete {@id = nil}
        !exists?
      end

      # Updates the attributes of a playlist.
      # @return [Boolean] whether the playlist was successfully updated.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} is not an
      #   authenticated Yt::Account with permissions to update the playlist.
      # @param [Hash] attributes the attributes to update.
      # @option attributes [String] :title The new playlist’s title.
      #   Cannot have more than 100 characters. Can include the characters
      #   < and >, which are replaced to ‹ › in order to be accepted by YouTube.
      # @option attributes [String] :description The new playlist’s description.
      #   Cannot have more than 5000 bytes. Can include the characters
      #   < and >, which are replaced to ‹ › in order to be accepted by YouTube.
      # @option attributes [Array<String>] :tags The new playlist’s tags.
      #   Cannot have more than 500 characters. Can include the characters
      #   < and >, which are replaced to ‹ › in order to be accepted by YouTube.
      # @option attributes [String] :privacy_status The new playlist’s privacy
      #   status. Must be one of: private, unscheduled, public.
      # @example Update title and description of a playlist.
      #   playlist.update title: 'New title', description: 'New description'
      # @example Update tags and status of a playlist.
      #   playlist.update tags: ['new', 'tags'], privacy_status: 'public'
      def update(attributes = {})
        super
      end

      # Adds a video to the playlist.
      # Unlike {#add_video!}, does not raise an error if video can’t be added.
      # @param [String] video_id the video to add to the playlist.
      # @param [Hash] options the options on how to add the video.
      # @option options [Integer] :position where to add video in the playlist.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} is not an
      #   authenticated Yt::Account with permissions to update the playlist.
      # @return [Yt::PlaylistItem] the item added to the playlist.
      def add_video(video_id, options = {})
        playlist_item_params = playlist_item_params(video_id, options)
        playlist_items.insert playlist_item_params, ignore_errors: true
      end

      # Adds a video to the playlist.
      # Unlike {#add_video}, raises an error if video can’t be added.
      # @param [String] video_id the video ID to add to the playlist.
      # @param [Hash] options the options on how to add the video.
      # @option options [Integer] :position where to add video in the playlist.
      # @raise [Yt::Errors::RequestError] if video can’t be added.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} is not an
      #   authenticated Yt::Account with permissions to update the playlist.
      # @return [Yt::PlaylistItem] the item added to the playlist.
      def add_video!(video_id, options = {})
        playlist_item_params = playlist_item_params(video_id, options)
        playlist_items.insert playlist_item_params
      end

      # Adds multiple videos to the playlist.
      # Unlike {#add_videos!}, does not raise an error if videos can’t be added.
      # @param [Array<String>] video_ids the video IDs to add to the playlist.
      # @param [Hash] options the options on how to add the videos.
      # @option options [Integer] :position where to add videos in the playlist.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} is not an
      #   authenticated Yt::Account with permissions to update the playlist.
      # @return [Array<Yt::PlaylistItem>] the items added to the playlist.
      def add_videos(video_ids = [], options = {})
        video_ids.map{|video_id| add_video video_id, options}
      end

      # Adds multiple videos to the playlist.
      # Unlike {#add_videos}, raises an error if videos can’t be added.
      # @param [Array<String>] video_ids the video IDs to add to the playlist.
      # @param [Hash] options the options on how to add the videos.
      # @option options [Integer] :position where to add videos in the playlist.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} is not an
      #   authenticated Yt::Account with permissions to update the playlist.
      # @return [Array<Yt::PlaylistItem>] the items added to the playlist.
      def add_videos!(video_ids = [], options = {})
        video_ids.map{|video_id| add_video! video_id, options}
      end

      # Deletes the playlist’s items matching all the given attributes.
      # @return [Array<Boolean>] whether each playlist item matching the given
      #   attributes was deleted.
      # @raise [Yt::Errors::RequestError] if {Resource#auth auth} is not an
      #   authenticated Yt::Account with permissions to update the playlist.
      # @param [Hash] attributes the attributes to match the items by.
      # @option attributes [<String, Regexp>] :title The item’s title.
      #   Pass a String for perfect match or a Regexp for advanced match.
      # @option attributes [<String, Regexp>] :description The item’s
      #   description. Pass a String (perfect match) or a Regexp (advanced).
      # @option attributes [String] :privacy_status The item’s privacy status.
      # @option attributes [String] :video_id The item’s video ID.
      def delete_playlist_items(attributes = {})
        playlist_items.delete_all attributes
      end

    ### ASSOCIATIONS ###

      # @!attribute [r] playlist_items
      #   @return [Yt::Collections::PlaylistItems] the playlist’s items.
      has_many :playlist_items

    ### ANALYTICS ###

      # @macro reports

      # @macro report_by_playlist_dimensions
      has_report :views, Integer

      # @macro report_by_playlist_dimensions
      has_report :estimated_minutes_watched, Integer

      # @macro report_by_gender_and_age_group
      has_report :viewer_percentage, Float

      # @macro report_by_day_and_state
      has_report :average_view_duration, Integer

      # @macro report_by_day_and_state
      has_report :playlist_starts, Integer

      # @macro report_by_day_and_state
      has_report :average_time_in_playlist, Float

      # @macro report_by_day_and_state
      has_report :views_per_playlist_start, Float

    ### PRIVATE API ###

      # @private
      # Override Resource's new to set content details as well
      # if the response includes them
      def initialize(options = {})
        super options
        if options[:content_details]
          @content_detail = ContentDetail.new data: options[:content_details]
        end
      end

      # @private
      # Tells `has_reports` to retrieve the reports from YouTube Analytics API
      # either as a Channel or as a Content Owner.
      # @see https://developers.google.com/youtube/analytics/channel_reports
      # @see https://developers.google.com/youtube/analytics/content_owner_reports
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

      # @private
      def exists?
        !@id.nil?
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

      # For updating playlist with content owner auth.
      # @see https://developers.google.com/youtube/v3/docs/playlists/update
      def update_params
        params = super
        params[:params] ||= {}
        params[:params].merge! auth.update_playlist_params
        params
      end
    end
  end
end
