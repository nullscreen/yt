require 'yt/actions/delete_all'
require 'yt/actions/insert'
require 'yt/actions/list'
require 'yt/errors/request_error'

module Yt
  module Collections
    class Base
      include Actions::DeleteAll
      include Actions::Insert
      include Actions::List

      def initialize(options = {})
        @parent = options[:parent]
        @auth = options[:auth]
        @extra_params = {}
        @extra_parts = []
      end

      def self.of(parent)
        new parent: parent, auth: parent.auth
      end

      def where(conditions = {})
        @items = []
        @extra_params = conditions
        self
      end

      def include(*parts)
        @items = []
        @extra_parts = parts
        self
      end
    end
  end
end