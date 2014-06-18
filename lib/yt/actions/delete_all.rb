require 'yt/actions/list'
require 'yt/models/request'

module Yt
  module Actions
    module DeleteAll
      include List

    private

      def do_delete_all(params = {}, options = {})
        list_all(params).map do |item|
          item.delete options
        end.tap { @items = [] }
      end

      def list_all(params = {})
        list.find_all do |item|
          params.all? do |method, value|
            # TODO: could be symbol etc...
            item.respond_to?(method) && case value
            when Regexp then item.send(method) =~ value
            else item.send(method) == value
            end
          end
        end
      end
    end
  end
end