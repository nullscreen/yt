require 'yt/models/base'

module Yt
  module Models
    # @private
    class Revocation < Base
      def initialize(options = {})
        @data = options[:data]
      end
    end
  end
end