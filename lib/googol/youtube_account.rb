require 'googol/authenticable'
require 'googol/readable'

module Googol
  # Provides read & write access to a Youtube account (also known as Channel).
  #
  # @example Like the video "Tongue" by R.E.M. as a specific Youtube account:
  #   * Set up two pages: one with a link to authenticate, one to redirect to
  #   * In the first page, add a link to the authentication page:
  #
  #       Googol::YoutubeAccount.oauth_url(redirect_url)
  #
  #   * The user authenticates and lands on the second page, with an extra +code+ query parameter
  #   * Use the authorization code to initialize the YoutubeAccount and like the video:
  #
  #       account = Googol::YoutubeAccount.new code: code, redirect_url: redirect_url
  #       account.perform! :like, :video, 'Kd5M17e7Wek' # => likes the video
  #
  class YoutubeAccount
    include Authenticable
    include Readable
    # Return the profile info of a Youtube account/channel.
    #
    # @see https://developers.google.com/youtube/v3/docs/channels#resource
    #
    # @return [Hash]
    #   * :id [String] The ID that YouTube uses to uniquely identify the channel.
    #   * :etag [String] The Etag of this resource.
    #   * :kind [String] The value will be youtube#channel.
    #   * :snippet [Hash]
    #     - :title [String] The channel's title.
    #     - :description [String] The channel's description.
    #     - :publishedAt [String] The date and time that the channel was created. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
    #     - :thumbnails [Hash]
    #       + :default [Hash] Default thumbnail URL (88px x 88px)
    #       + :medium [Hash] Medium thumbnail URL (88px x 88px)
    #       + :high [Hash] High thumbnail URL (88px x 88px)
    def info
      @info ||= request! method: :get,
        auth: credentials[:access_token],
        host: 'https://www.googleapis.com',
        path: '/youtube/v3/channels?part=id,snippet&mine=true',
        valid_if: -> resp, body {resp.code == '200' && body['items'].any?},
        extract: -> body {body['items'].first}
    end

    ## Promote a Youtube target resource on this Youtube Channel
    # Note that liking a video does not also subscribe to a channel
    def perform!(activity, target_kind, target_id)
      params = {}.tap do |params|
        params[:method] = :post
        params[:auth] = credentials[:access_token]
        params[:host] = 'https://www.googleapis.com'

        case [activity.to_sym, target_kind.to_sym]
        when [:like, :video]
          params[:path] = "/youtube/v3/videos/rate?rating=like&id=#{target_id}"
          params[:valid_if] = -> response, body {response.code == '204'}
        when [:subscribe_to, :channel]
          params[:json] = true
          params[:path] = '/youtube/v3/subscriptions?part=snippet'
          params[:body] = {snippet: {resourceId: {channelId: target_id}}}
          params[:valid_if] = -> response, body {response.code == '200'}
        else
          raise RequestError, "#{activity} invalid for #{target_kind} #{target_id}"
        end
      end
      request! params
    end

    # Set the scopes to grant access to Youtube account
    #
    # @see https://developers.google.com/youtube/v3/guides/authentication
    def self.oauth_scopes
      %w(https://www.googleapis.com/auth/youtube)
    end
  end
end