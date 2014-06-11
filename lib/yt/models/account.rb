require 'yt/models/base'
require 'yt/associations/authentications'

module Yt
  module Models
    # Provides methods to access a YouTube account.
    class Account < Base
      include Associations::Authentications

      has_one :channel, delegate: [:videos, :playlists, :create_playlist, :delete_playlists, :update_playlists]
      has_one :user_info, delegate: [:id, :email, :has_verified_email?, :gender, :name, :given_name, :family_name, :profile_url, :avatar_url, :locale, :hd]
      has_many :videos

      def videos_params
        {forMine: true}
      end
    end
  end
end