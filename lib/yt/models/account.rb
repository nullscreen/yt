require 'yt/models/base'

module Yt
  module Models
    # Provides methods to interact with YouTube accounts.
    # @see https://developers.google.com/youtube/v3/guides/authentication
    class Account < Base
      # @!attribute [r] channel
      #   @return [Yt::Models::Channel] the account’s channel.
      has_one :channel
      delegate :playlists, :create_playlist, :delete_playlists, to: :channel

      # @!attribute [r] user_info
      #   @return [Yt::Models::UserInfo] the account’s profile information.
      has_one :user_info
      delegate :id, :email, :has_verified_email?, :gender, :name, :given_name,
        :family_name, :profile_url, :avatar_url, :locale, :hd, to: :user_info

      # @!attribute [r] videos
      #   @return [Yt::Collections::Videos] the videos owned by the account.
      has_many :videos

      # @return [String] name of the CMS account, if the account is partnered.
      # @return [nil] if the account is not a partnered content owner.
      attr_reader :owner_name

      has_authentication

      # @private
      # Tells `has_many :videos` that account.videos should return all the
      # videos *owned by* the account (public, private, unlisted).
      def videos_params
        {forMine: true}
      end
    end
  end
end