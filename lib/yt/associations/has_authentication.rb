module Yt
  module Associations
    # Provides authentication methods to YouTube resources, which allows to
    # access to content detail set-specific methods like `access_token`.
    #
    # YouTube resources with authentication are: {Yt::Models::Account accounts}.
    module HasAuthentication
      def has_authentication
        require 'yt/collections/authentications'
        require 'yt/errors/missing_auth'
        require 'yt/errors/no_items'
        require 'yt/errors/unauthorized'

        include Associations::Authenticable
      end
    end

    module Authenticable
      delegate :access_token, :refresh_token, :expires_at, to: :authentication

      def initialize(options = {})
        @access_token = options[:access_token]
        @refresh_token = options[:refresh_token]
        @expires_at = options[:expires_at]
        @authorization_code = options[:authorization_code]
        @redirect_uri = options[:redirect_uri]
        @scopes = options[:scopes]
      end

      def auth
        self
      end

      def authentication
        @authentication = current_authentication
        @authentication ||= use_refresh_token! if @refresh_token
        @authentication ||= use_authorization_code! if @authorization_code
        @authentication ||= raise_missing_authentication!
      end

      def authentication_url
        host = 'accounts.google.com'
        path = '/o/oauth2/auth'
        query = authentication_url_params.to_param
        URI::HTTPS.build(host: host, path: path, query: query).to_s
      end

      # Obtains a new access token.
      # Returns true if the new access token is different from the previous one
      def refresh
        old_access_token = authentication.access_token
        @authentication = @access_token = @refreshed_authentications = nil
        old_access_token != authentication.access_token
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
      # can only be used once). On failure, raise an error.
      def use_authorization_code!
        new_authentications.first!
      rescue Errors::NoItems => error
        raise Errors::Unauthorized, error.to_param
      end

      # Tries to obtain an access token using the refresh token (which can
      # be used multiple times). On failure, raise an error.
      def use_refresh_token!
        refreshed_authentications.first!
      rescue Errors::NoItems => error
        raise Errors::Unauthorized, error.to_param
      end

      def raise_missing_authentication!
        error = {}.tap do |params|
          params[:authentication_url] = authentication_url
          params[:scopes] = @scopes
          params[:redirect_uri] = @redirect_uri
        end
        raise Errors::MissingAuth, error
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