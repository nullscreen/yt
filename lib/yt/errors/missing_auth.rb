require 'yt/errors/request_error'

module Yt
  module Errors
    class MissingAuth < RequestError
      def message
        <<-MSG.gsub(/^ {8}/, '')
        A request to YouTube API was sent without a valid authentication.

        #{more_details}
        MSG
      end

      def more_details
        if scopes && authentication_url && redirect_uri
          more_details_with_authentication_url
        elsif scopes && user_code && verification_url
          more_details_with_verification_url
        else
          more_details_without_url
        end
      end

    private

      def more_details_with_authentication_url
        <<-MSG.gsub(/^ {8}/, '')
        You can ask YouTube accounts to authenticate your app for the scopes
        #{scopes} by directing them to #{authentication_url}.

        After they provide access to their account, they will be redirected to
        #{redirect_uri} with a 'code' query parameter that you can read and use
        to build an authorized account object by running:

        Yt::Account.new authorization_code: code, redirect_uri: "#{redirect_uri}"
        MSG
      end

      def more_details_with_verification_url
        <<-MSG.gsub(/^ {8}/, '')
        Please authenticate your app by visiting the page #{verification_url}
        and entering the code #{user_code} before continuing.
        MSG
      end

      def more_details_without_url
        <<-MSG.gsub(/^ {8}/, '')
        If you know the access token of the YouTube you want to authenticate
        with, build an authorized account object by running:

        Yt::Account.new access_token: access_token

        If you know the refresh token of the YouTube you want to authenticate
        with, build an authorized account object by running:

        Yt::Account.new refresh_token: refresh_token
        MSG
      end

      def scopes
        @msg[:scopes]
      end

      def authentication_url
        @msg[:authentication_url]
      end

      def redirect_uri
        @msg[:redirect_uri]
      end

      def user_code
        @msg[:user_code]
      end

      def verification_url
        @msg[:verification_url]
      end
    end
  end
end