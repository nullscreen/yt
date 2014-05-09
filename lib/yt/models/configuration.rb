module Yt
  # Stores runtime configuration information.
  #
  # Configuration options are loaded from `~/.yt`, `.yt`, command line
  # switches, and the `YT_OPTS` environment variable (listed in lowest to
  # highest precedence).
  #
  # @example A server-to-server YouTube client app
  #
  #   Yt.configure do |config|
  #     config.scenario = :server_app
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
    attr_accessor :scenario, :api_key, :client_id, :client_secret, :account

    def initialize
      @scenario = :web_app
    end
  end
end