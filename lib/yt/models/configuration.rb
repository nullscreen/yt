module Yt
  module Models
    # Stores runtime configuration information.
    #
    # Configuration options are loaded from `~/.yt`, `.yt`, command line
    # switches, and the `YT_OPTS` environment variable (listed in lowest to
    # highest precedence).
    #
    # @example A server-to-server YouTube client app
    #
    #   Yt.configure do |config|
    #     config.api_key = 'ABCDEFGHIJ1234567890'
    #   end
    #
    # @example A web YouTube client app
    #
    #   Yt.configure do |config|
    #     config.client_id = 'ABCDEFGHIJ1234567890'
    #     config.client_secret = 'ABCDEFGHIJ1234567890'
    #   end
    #
    class Configuration
      attr_accessor :api_key, :client_id, :client_secret

      def initialize
        @client_id = ENV['YT_CLIENT_ID']
        @client_secret = ENV['YT_CLIENT_SECRET']
        @api_key = ENV['YT_API_KEY']
      end
    end
  end
end