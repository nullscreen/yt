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
        require "yt/collections/#{attributes}"
        collection_name = attributes.to_s.sub(/.*\./, '').camelize.pluralize
        collection = "Yt::Collections::#{collection_name}".constantize
        define_memoized_method(attributes) { collection.of self }
      end

      # @private
      def self.has_one(attribute)
        attributes = attribute.to_s.pluralize
        has_many attributes
        define_memoized_method(attribute) { send(attributes).first! }
      end

    private

      # A wrapper around Ruby’s +define_method+ that, in addition to adding an
      # instance method called +name+, adds an instance variable called +@name+
      # that stores the result of +name+ the first time is invoked, and returns
      # it every other time. Especially useful if invoking +name+ takes a long
      # time.
      def self.define_memoized_method(name, &method)
        define_method name do
          ivar = instance_variable_get "@#{name}"
          instance_variable_set "@#{name}", ivar || instance_eval(&method)
        end
      end
    end
  end

  # By including Models in the main namespace, models can be initialized with
  # the shorter notation Yt::Video.new, rather than Yt::Models::Video.new.
  include Models
end