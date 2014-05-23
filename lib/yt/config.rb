require 'yt/models/configuration'

module Yt
  # Provides methods to read and write runtime configuration information.
  #
  # Configuration options are loaded from `~/.yt`, `.yt`, command line
  # switches, and the `YT_OPTS` environment variable (listed in lowest to
  # highest precedence).
  #
  # @note Config is the only module auto-loaded in the Yt module,
  #       in order to have a syntax as easy as Yt.configure
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
  module Config
    # Yields the global configuration to a block.
    # @yield [Yt::Configuration] global configuration
    #
    # @example
    #   Yt.configure do |config|
    #     config.api_key = 'ABCDEFGHIJ1234567890'
    #   end
    # @see Yt::Configuration
    def configure
      yield configuration if block_given?
    end

    # Returns the global [Configuration](Yt/Configuration) object. While you
    # _can_ use this method to access the configuration, the more common
    # convention is to use [Yt.configure](Yt#configure-class_method).
    #
    # @example
    #     Yt.configuration.api_key = 'ABCDEFGHIJ1234567890'
    # @see Yt.configure
    # @see Yt::Configuration
    def configuration
      @configuration ||= Yt::Configuration.new
    end
  end

  extend Config
end