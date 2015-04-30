require 'yt/models/base'

module Yt
  module Models
    # @private
    # Provides methods to retrieve an account’s user profile.
    # @see https://developers.google.com/+/api/latest/people/getOpenIdConnect
    class UserInfo < Base
      def initialize(options = {})
        @data = options[:data]
      end

      has_attribute :id, default: ''
      has_attribute :email, default: ''
      has_attribute :verified_email, default: false, camelize: false
      has_attribute :name, default: ''
      has_attribute :given_name, default: '', camelize: false
      has_attribute :family_name, default: '', camelize: false
      has_attribute :link, default: ''
      has_attribute :picture, default: ''
      has_attribute :gender, default: ''
      has_attribute :locale, default: ''
      has_attribute :hd, default: ''
    end
  end
end
