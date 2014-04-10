require 'googol/authenticable'

module Googol
  # Provides read & write access to a Google (or Google+) account.
  #
  # @example Retrieve the email and given name of a Google account:
  #   * Set up two pages: one with a link to authenticate, one to redirect to
  #   * In the first page, add a link to the authentication page:
  #
  #       Googol::GoogleAccount.oauth_url(redirect_url)
  #
  #   * The user authenticates and lands on the second page, with an extra +code+ query parameter
  #   * Use the authorization code to initialize the GoogleAccount and retrieve information:
  #
  #       account = Googol::GoogleAccount.new code: code, redirect_url: redirect_url
  #       account.email # => 'user@example.com'
  #       account.given_name # => 'Example user'
  #
  class GoogleAccount
    include Authenticable
    # Return the profile info of a Google account in OpenID Connect format.
    #
    # @see https://developers.google.com/+/api/latest/people/getOpenIdConnect
    #
    # @return [Hash]
    #   * :id [String] The ID of the authenticated account
    #   * :email [String] The account’s email address.
    #   * :verified_email [String] Boolean flag which is true if the email address is verified.
    #   * :name [String] The account’s full name.
    #   * :given_name [String] The account’s given (first) name.
    #   * :family_name [String] The account’s family (last) name.
    #   * :link [String] The URL of the account’s profile page.
    #   * :picture [String] The URL of the account’s profile picture.
    #   * :gender [String] The account’s gender
    #   * :locale [String] The account’s preferred locale.
    #   * :hd [String] The hosted domain name for the accounts’s Google Apps.
    def info
      @info ||= request! auth: credentials[:access_token],
        host: 'https://www.googleapis.com', path: '/oauth2/v2/userinfo'
    end

    # Define a method to return each attribute of the profile separately.
    #
    # @macro [attach] attribute.name
    #   @method $1()
    #   Return the $1 attribute of the Google Account.
    #
    def self.attribute(name)
      define_method(name) { info[name] }
    end

    attribute :id
    attribute :email
    attribute :verified_email
    attribute :name
    attribute :given_name
    attribute :family_name
    attribute :link
    attribute :picture
    attribute :gender
    attribute :locale
    attribute :hd

    # Set the scopes to grant access to Google user profile and email
    #
    # @see https://developers.google.com/+/api/oauth#profile
    def self.oauth_scopes
      %w(profile email)
    end
  end
end