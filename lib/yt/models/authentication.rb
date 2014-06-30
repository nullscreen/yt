module Yt
  module Models
    # Provides methods to authenticate with YouTube (and Google) API.
    # @see https://developers.google.com/accounts/docs/OAuth2
    class Authentication

      # Before your application can access private data using a Google API,
      # it must obtain an access token that grants access to that API.
      #
      # A single access token can grant varying degrees of access to multiple
      # APIs. A variable parameter called scope controls the set of resources
      # and operations that an access token permits.
      #
      # After an application obtains an access token, it sends the token to a
      # Google API in an HTTP authorization header.
      #
      # Access tokens are valid only for the set of operations and resources
      # described in the scope of the token request. For example, if an access
      # token is issued for the Google+ API, it does not grant access to the
      # Google Contacts API.
      #
      # @return [String] the OAuth2 Google access token.
      attr_reader :access_token

      # Access tokens have limited lifetimes. If your application needs access
      # to a Google API beyond the lifetime of a single access token, it can
      # obtain a refresh token. A refresh token allows your application to
      # obtain new access tokens.
      #
      # Save refresh tokens in secure long-term storage and continue to
      # use them as long as they remain valid. Limits apply to the number of
      # refresh tokens that are issued per client-user combination, and per
      # user across all clients, and these limits are different. If your
      # application requests enough refresh tokens to go over one of the
      # limits, older refresh tokens stop working.
      #
      # There is currently a 25-token limit per Google user account.
      # If a user account has 25 valid tokens, the next authentication request
      # succeeds, but quietly invalidates the oldest outstanding token without
      # any user-visible warning.
      #
      # @return [String] the OAuth2 Google refresh token.
      attr_reader :refresh_token

      # Access tokens have limited lifetimes. If your application needs access
      # to a Google API beyond the lifetime of a single access token, it can
      # obtain a refresh token.
      #
      # A refresh token allows your application to
      # obtain new access tokens.
      #
      # @return [Time] the time when access token no longer works.
      attr_reader :expires_at

      def initialize(data = {})
        @access_token = data['access_token']
        @refresh_token = data['refresh_token']
        @error = data['error']
        @expires_at = expiration_date data.slice('expires_at', 'expires_in')
      end

      # @return [Boolean] whether the access token has expired.
      def expired?
        @expires_at && @expires_at.past?
      end

      # @return [Boolean] whether the device auth is pending
      def pending?
        @error == 'authorization_pending'
      end

    private

      def expiration_date(options = {})
        if options['expires_in']
          Time.now + options['expires_in'].seconds
        else
          Time.parse options['expires_at'] rescue nil
        end
      end
    end
  end
end