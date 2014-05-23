require 'yt/collections/authentications'
require 'yt/config'
require 'yt/errors/no_items'
require 'yt/errors/missing_auth'

module Yt
  module Associations
    # Provides the `has_one :access_token` method to YouTube resources, which
    # allows to access to content detail set-specific methods like `access_token`.
    # YouTube resources with access tokens are: accounts.
    module Authentications
      def authentication
        @authentication = current_authentication
        @authentication ||= new_authentication || refreshed_authentication!
      end

      def authentication_url
        host = 'accounts.google.com'
        path = '/o/oauth2/auth'
        query = authentication_url_params.to_param
        URI::HTTPS.build(host: host, path: path, query: query).to_s
      end

    private

      def current_authentication
        @authentication ||= Yt::Authentication.new current_data if @access_token
        @authentication unless @authentication.nil? || @authentication.expired?
      end

      def current_data
        {}.tap do |data|
          data['access_token'] = @access_token
          data['expires_at'] = @expires_at
          data['refresh_token'] = @refresh_token
        end
      end

      # Tries to obtain an access token using the authorization code (which
      # can only be used once). On failure, does not raise an error because
      # the access token might still be retrieved with a refresh token.
      def new_authentication
        new_authentications.first!
      rescue Errors::NoItems => error
        nil
      end

      # Tries to obtain an access token using the refresh token (which can
      # be used multiple times). On failure, raise an error because there are
      # no more options to obtain an access token.
      def refreshed_authentication!
        refreshed_authentications.first!
      rescue Errors::NoItems => error
        raise Errors::MissingAuth, error.to_param
      end

      def new_authentications
        @new_authentications ||= Collections::Authentications.of(self).tap do |auth|
          auth.auth_params = new_authentication_params
        end
      end

      def refreshed_authentications
        @refreshed_authentications ||= Collections::Authentications.of(self).tap do |auth|
          auth.auth_params = refreshed_authentication_params
        end
      end

      def authentication_url_params
        {}.tap do |params|
          params[:client_id] = client_id
          params[:scope] = authentication_scope
          params[:redirect_uri] = @redirect_uri
          params[:response_type] = :code
          params[:access_type] = :offline
          # params[:include_granted_scopes] = true
        end
      end

      def authentication_scope
        @scopes.map do |scope|
          "https://www.googleapis.com/auth/#{scope}"
        end.join(' ') if @scopes.is_a?(Array)
      end

      def new_authentication_params
        {}.tap do |params|
          params[:client_id] = client_id
          params[:client_secret] = client_secret
          params[:code] = @authorization_code
          params[:redirect_uri] = @redirect_uri
          params[:grant_type] = :authorization_code
        end
      end

      def refreshed_authentication_params
        {}.tap do |params|
          params[:client_id] = client_id
          params[:client_secret] = client_secret
          params[:refresh_token] = @refresh_token
          params[:grant_type] = :refresh_token
        end
      end

      def client_id
        Yt.configuration.client_id
      end

      def client_secret
        Yt.configuration.client_secret
      end
    end
  end
end