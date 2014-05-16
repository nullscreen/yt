require 'yt/models/base'
require 'yt/config'

module Yt
  # Provides methods to access a YouTube account.
  class Account < Base

    has_one :channel, delegate: [:videos, :playlists, :create_playlist, :delete_playlists, :update_playlists]
    has_one :user_info, delegate: [:id, :email, :has_verified_email?, :gender,
      :name, :given_name, :family_name, :profile_url, :avatar_url, :locale, :hd]

    def initialize(options = {})
      @access_token = options[:access_token]
      @refresh_token = options[:refresh_token]
      @redirect_url = options[:redirect_url]
    end

    def access_token
      @access_token ||= refresh_access_token || get_access_token
    end

    def auth
      self
    end

  private

    # Obtain a new access token using the refresh token
    def refresh_access_token
      if @refresh_token
        body = {grant_type: 'refresh_token', refresh_token: @refresh_token}
        request = Request.new auth_params.deep_merge(body: body)
        response = request.run
        response.body['access_token']
      end
    end

    def auth_params
      {
        host: 'accounts.google.com',
        path: '/o/oauth2/token',
        format: :json,
        body_type: :form,
        method: :post,
        body: {
          client_id: Yt.configuration.client_id,
          client_secret: Yt.configuration.client_secret
        }
      }
    end
  end
end