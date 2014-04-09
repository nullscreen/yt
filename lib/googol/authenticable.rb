require 'uri'
require 'cgi'
require 'googol/client_tokens'
require 'googol/requestable'

module Googol
  # Provides methods to authenticate as an account (either Google or Youtube).
  module Authenticable
    include ClientTokens
    include Requestable

    # Initialize an object with either an authorization code or a refresh token
    #
    # @see https://developers.google.com/accounts/docs/OAuth2
    #
    # @param [Hash] attrs Authentication credentials to access the account
    # @option attrs [String] :code The OAuth2 authorization code
    # @option attrs [String] :redirect_url The page to redirect after the OAuth2 page
    # @option attrs [String] :refresh_token The refresh token for offline access
    def initialize(attrs = {})
      @code = attrs[:code]
      @refresh_token = attrs[:refresh_token]
      @redirect_url = attrs.fetch :redirect_url, 'http://example.com/'
    end

    # Return the authorization credentials of an account for this app.
    #
    # @see ...
    #
    # @return [Hash]
    #   * :client_id [String] ...
    #   * :client_secret [String] ...
    #   * ...
    def credentials
      @credentials ||= request! method: :post,
        host: 'https://accounts.google.com',
        path: '/o/oauth2/token',
        body: credentials_params,
        valid_if: -> response, body {response.code == '200'}
    end

  private

    # Provides the credentials to access Google API as an authorized user.
    #
    # There are ways to do this:
    # - For first-time users (who do not have a refresh token but only an
    #   authorization code): the code is submitted to Google to obtain an
    #   access token (to use immediately) and a refresh_token
    # - For existing users (who have a refresh token): the refresh token is
    #   submitted to Google to obtain a new access token
    def credentials_params
      if @refresh_token
        {grant_type: :refresh_token, refresh_token: @refresh_token}
      else
        {grant_type: :authorization_code, code: @code, redirect_uri: @redirect_url}
      end.merge client_id: client_id, client_secret: client_secret
    end

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      include ClientTokens
      # Returns the URL for users to authorize this app to access their account
      #
      # @param [String] redirect_url The page to redirect after the OAuth2 page
      #
      # @return [String] URL of the OAuth2 Authorization page.
      #
      # @note The redirect_url *must* match one of the redirect URLs whitelisted
      #       for the app in the Google Developers Console
      #
      # @see https://console.developers.google.com
      def oauth_url(redirect_url = 'http://example.com/')
        params = {
          client_id: client_id,
          scope: oauth_scopes.join(' '),
          redirect_uri: redirect_url,
          response_type: :code,
          access_type: :offline,
          approval_prompt: :force
        }
        q = params.map{|k,v| "#{CGI.escape k.to_s}=#{CGI.escape v.to_s}"}.join '&'
        args = {host: 'accounts.google.com', path: '/o/oauth2/auth', query: q}
        URI::HTTPS.build(args).to_s
      end

      # Set the scopes to grant access to an account.
      # This method is meant to be overridden.
      def oauth_scopes
      end
    end
  end
end