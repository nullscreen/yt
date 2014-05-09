require 'yt/models/base'

module Yt
  class UserInfo < Base
    def initialize(options = {})
      @data = options[:data]
    end

    # @return [String] User ID
    def id
      @id ||= @data.fetch 'id', ''
    end

    # Return the email of the YouTube account.
    #
    # @return [String] Email of the YouTube account
    def email
      @email ||= @data.fetch 'email', ''
    end

    # @return [Boolean] Email is verified?
    def has_verified_email?
      @verified_email ||= @data.fetch 'verified_email', false
    end

    # @return [String] name
    def name
      @name ||= @data.fetch 'name', ''
    end

    # @return [String] given_name
    def given_name
      @given_name ||= @data.fetch 'given_name', ''
    end

    # @return [String] family_name
    def family_name
      @family_name ||= @data.fetch 'family_name', ''
    end

    # @return [String] family_name
    def profile_url
      @profile_url ||= @data.fetch 'link', ''
    end

    # @return [String] avatar_url
    def avatar_url
      @avatar_url ||= @data.fetch 'picture', ''
    end

    # @return [String] gender
    def gender
      @gender ||= @data.fetch 'gender', ''
    end

    # @return [String] locale
    def locale
      @locale ||= @data.fetch 'locale', ''
    end

    # @return [String] hd
    def hd
      @hd ||= @data.fetch 'hd', ''
    end
  end
end