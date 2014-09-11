require 'open-uri'
require 'yt/models/base'

module Yt
  module Models
    # Provides methods to interact with YouTube accounts.
    # @see https://developers.google.com/youtube/v3/guides/authentication
    class Account < Base
      # @!attribute [r] channel
      #   @return [Yt::Models::Channel] the account’s channel.
      has_one :channel
      delegate :playlists, :delete_playlists,
        :subscribed_channels, to: :channel

      # @!attribute [r] user_info
      #   @return [Yt::Models::UserInfo] the account’s profile information.
      has_one :user_info
      delegate :id, :email, :has_verified_email?, :gender, :name, :given_name,
        :family_name, :profile_url, :avatar_url, :locale, :hd, to: :user_info

      # @!attribute [r] videos
      #   @return [Yt::Collections::Videos] the videos owned by the account.
      has_many :videos

      # @!attribute [r] subscribers
      #   @return [Yt::Collections::Subscribers] the channels subscribed to the account.
      has_many :subscribers

      # @return [String] name of the CMS account, if the account is partnered.
      # @return [nil] if the account is not a partnered content owner.
      attr_reader :owner_name

      has_authentication

      # @!attribute [r] resumable_sessions
      #   @return [Yt::Collections::ResumableSessions] the sessions used to
      #     upload videos using the resumable upload protocol.
      has_many :resumable_sessions

      # @!attribute [r] content_owners
      #   @return [Yt::Collections::ContentOwners] the content_owners accessible
      #     by the account.
      has_many :content_owners

      # @!attribute [r] playlists
      #   @return [Yt::Collections::Playlists] the account’s playlists.
      has_many :playlists

      # Uploads a video
      # @param [String] path_or_url the video to upload. Can either be the
      #   path of a local file or the URL of a remote file.
      # @param [Hash] params the metadata to add to the uploaded video.
      # @option params [String] :title The video’s title.
      # @option params [String] :description The video’s description.
      # @option params [Array<String>] :title The video’s tags.
      # @option params [String] :privacy_status The video’s privacy status.
      # @return [Yt::Models::Video] the newly uploaded video.
      def upload_video(path_or_url, params = {})
        file = open path_or_url, 'rb'
        session = resumable_sessions.insert file.size, params
        session.upload_video file
      end

      def create_playlist(params = {})
        playlists.insert params
      end

      # @private
      # Tells `has_many :videos` that account.videos should return all the
      # videos *owned by* the account (public, private, unlisted).
      def videos_params
        {for_mine: true}
      end
    end
  end
end