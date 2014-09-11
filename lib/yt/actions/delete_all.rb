# encoding: UTF-8
require 'yt/actions/list'
require 'yt/request'

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
            when Array then item.send(method) == value.map{|item| item.to_s.gsub('<', '‹').gsub('>', '›')}
            else item.send(method) == value.to_s.gsub('<', '‹').gsub('>', '›')
            end
          end
        end
      end
    end
  end
end