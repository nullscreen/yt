require 'yt/actions/delete'
require 'yt/actions/update'
require 'yt/errors/request_error'

require 'active_support/core_ext/module/delegation' # for delegate
require 'active_support/core_ext/string/inflections' # for camelize

module Yt
  module Models
    class Base
      include Actions::Delete
      include Actions::Update

      # @private
      def self.has_many(attributes)
        attributes = attributes.to_s
        require "yt/collections/#{attributes}"
        mod = attributes.sub(/.*\./, '').camelize
        collection = "Yt::Collections::#{mod.pluralize}".constantize

        define_method attributes do
          ivar = instance_variable_get "@#{attributes}"
          instance_variable_set "@#{attributes}", ivar || collection.of(self)
        end
      end

      # @private
      def self.has_one(attribute)
        attributes = attribute.to_s.pluralize
        has_many attributes

        define_method attribute do
          ivar = instance_variable_get "@#{attribute}"
          instance_variable_set "@#{attribute}", ivar || send(attributes).first!
        end
      end
    end
  end

  include Models
end