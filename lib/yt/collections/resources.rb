require 'yt/collections/base'

module Yt
  module Collections
    class Resources < Base
      def initialize(options = {})
        @parent = options[:parent]
        @auth = options[:auth]
      end

      def self.of(parent)
        new parent: parent, auth: parent.auth
      end
    end
  end
end