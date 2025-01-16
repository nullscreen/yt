require 'yt/models/account'

module Yt
  module Models
    # Provides methods to interact with YouTube CMS accounts.
    # @see https://cms.youtube.com
    # @see https://developers.google.com/youtube/analytics/v1/content_owner_reports
    class ContentOwner < Account

      # @!attribute [r] partnered_channels
      #   @return [Yt::Collections::PartneredChannels] the channels managed by the CMS account.
      has_many :partnered_channels

      # @!attribute [r] live_cuepoints
      #   @return [Yt::Collections::LiveCuepoints] the live_cuepoints inserted by the content owner.
      has_many :live_cuepoints

      # @!attribute [r] claims
      #   @return [Yt::Collections::Claims] the claims administered by the content owner.
      has_many :claims

      # @!attribute [r] assets
      #   @return [Yt::Collection::Assets] the assets administered by the content owner.
      has_many :assets

      # @!attribute [r] references
      #   @return [Yt::Collections::References] the references administered by the content owner.
      has_many :references

      # @!attribute [r] policies
      #   @return [Yt::Collections::Policies] the policies saved by the content owner.
      has_many :policies

      # @return [String] The display name of the content owner.
      attr_reader :display_name

      # @!attribute [r] video_groups
      #   @return [Yt::Collections::VideoGroups] the video-groups managed by the
      #     content owner.
      has_many :video_groups

      # @!attribute [r] bulk_report_jobs
      #   @return [Yt::Collections::BulkReportJobs] the bulk reporting jobs managed by the
      #     content owner.
      has_many :bulk_report_jobs

      def initialize(options = {})
        super options
        @owner_name = options[:owner_name]
        @display_name = options[:display_name]
      end

      # Uploads a reference file to YouTube.
      # @param [String] path_or_url is the video or audio file to upload. Can either be the
      #   path of a local file or the URL of a remote file.
      # @param [Hash] params the metadata to add to the uploaded reference.
      # @option params [String] :asset_id The id of the asset the uploaded reference belongs to.
      # @option params [String] :content_type The type of content being uploaded.
      # @return [Yt::Models::Reference] the newly uploaded reference.
      def upload_reference_file(path_or_url, params = {})
        file = URI.open(path_or_url)
        session = resumable_sessions.insert file.size, params

        session.update(body: file) do |data|
          Yt::Reference.new id: data['id'], data: data, auth: self
        end
      end

      def create_reference(params = {})
        references.insert params
      end

      def create_asset(params = {})
        assets.insert params
      end

      def create_claim(params = {})
        claims.insert params
      end

    ### PRIVATE API ###

      # @private
      # Tells `has_many :resumable_sessions` what path to hit to upload a file.
      def upload_path
        '/upload/youtube/partner/v1/references'
      end

      # @private
      # Tells `has_many :videos` that account.videos should return all the
      # videos *on behalf of* the content owner (public, private, unlisted).
      def videos_params
        {for_content_owner: true, on_behalf_of_content_owner: @owner_name}
      end

      # @private
      # Tells `has_many :resumable_sessions` what params are set for the object
      # associated to the uploaded file.
      def upload_params
        {part: 'snippet,status', on_behalf_of_content_owner: self.owner_name}
      end

      # @private
      # Tells `has_many :video_groups` that content_owner.video_groups should
      # return all the video-groups *on behalf of* the content owner
      def video_groups_params
        {on_behalf_of_content_owner: @owner_name}
      end

      def playlist_items_params
        {on_behalf_of_content_owner: @owner_name}
      end

      def update_video_params
        {on_behalf_of_content_owner: @owner_name}
      end

      def update_playlist_params
        {on_behalf_of_content_owner: @owner_name}
      end

      def upload_thumbnail_params
        {on_behalf_of_content_owner: @owner_name}
      end

      def insert_playlist_item_params
        {on_behalf_of_content_owner: @owner_name}
      end
    end
  end
end
