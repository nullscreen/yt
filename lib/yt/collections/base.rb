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
      end

      def self.of(parent)
        new parent: parent, auth: parent.auth
      end

      def where(conditions = {})
        self.tap do
          @items = []
          @where_params = conditions
        end
      end

    private

      def apply_where_params!(params = {})
        params.merge!(@where_params ||= {})
      end
    end
  end
end