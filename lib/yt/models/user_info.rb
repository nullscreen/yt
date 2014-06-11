require 'yt/models/base'

module Yt
  module Models
    # Provides methods to retrieve an account’s user profile.
    # @see https://developers.google.com/+/api/latest/people/getOpenIdConnect
    class UserInfo < Base
      def initialize(options = {})
        @data = options[:data]
      end

      # @return [String] the user’s ID.
      def id
        @id ||= @data.fetch 'id', ''
      end

      # @return [String] the user’s email address.
      def email
        @email ||= @data.fetch 'email', ''
      end

      # @return [Boolean] whether the email address is verified.
      def has_verified_email?
        @verified_email ||= @data.fetch 'verified_email', false
      end

      # @return [String] the user's full name.
      def name
        @name ||= @data.fetch 'name', ''
      end

      # @return [String] the user’s given (first) name.
      def given_name
        @given_name ||= @data.fetch 'given_name', ''
      end

      # @return [String] the user’s family (last) name.
      def family_name
        @family_name ||= @data.fetch 'family_name', ''
      end

      # @return [String] the URL of the user’s profile page.
      def profile_url
        @profile_url ||= @data.fetch 'link', ''
      end

      # @return [String] the URL of the user’s profile picture.
      def avatar_url
        @avatar_url ||= @data.fetch 'picture', ''
      end

      # @return [String] the person’s gender. Possible values include, but
      #   are not limited to, "male", "female", "other".
      def gender
        @gender ||= @data.fetch 'gender', ''
      end

      # @return [String] the user’s preferred locale.
      def locale
        @locale ||= @data.fetch 'locale', ''
      end

      # @return [String] the hosted domain name for the user’s Google Apps
      #   account. For instance, example.com.
      def hd
        @hd ||= @data.fetch 'hd', ''
      end
    end
  end
end