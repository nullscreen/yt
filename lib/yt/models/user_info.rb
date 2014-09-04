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
      has_attribute :id, default: ''

      # @return [String] the user’s email address.
      has_attribute :email, default: ''

      # @return [Boolean] whether the email address is verified.
      has_attribute :has_verified_email?, from: :verified_email, default: false, camelize: false

      # @return [String] the user's full name.
      has_attribute :name, default: ''

      # @return [String] the user’s given (first) name.
      has_attribute :given_name, default: '', camelize: false

      # @return [String] the user’s family (last) name.
      has_attribute :family_name, default: '', camelize: false

      # @return [String] the URL of the user’s profile page.
      has_attribute :profile_url, from: :link, default: ''

      # @return [String] the URL of the user’s profile picture.
      has_attribute :avatar_url, from: :picture, default: ''

      # @return [String] the person’s gender. Possible values include, but
      #   are not limited to, "male", "female", "other".
      has_attribute :gender, default: ''

      # @return [String] the user’s preferred locale.
      has_attribute :locale, default: ''

      # @return [String] the hosted domain name for the user’s Google Apps
      #   account. For instance, example.com.
      has_attribute :hd, default: ''
    end
  end
end