require 'yt/actions/list'
require 'yt/models/request'

module Yt
  module Actions
    module DeleteAll
      include List

    private

      def do_delete_all(params = {})
        where(params).map do |item|
          item.delete
        end.tap { @items = [] }
      end

      def where(params = {})
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