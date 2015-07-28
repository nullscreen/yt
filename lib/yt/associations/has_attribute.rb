require 'yt/models/timestamp'

module Yt
  # @private
  module Associations
    # @private
    module HasAttribute
      def self.included(base)
        base.extend(ClassMethods)
      end

    private

      def type_cast(value, type)
        case [type]
          when [Time] then Yt::Timestamp.parse(value) if value
          when [Integer] then value.to_i if value
          when [Float] then value.to_f if value
          when [Symbol] then value.to_sym if value
          when [Hash] then value || {}
        end
      end

      module ClassMethods
        def has_attribute(attribute, options = {}, &block)
          define_memoized_method(attribute) do
            field = options.fetch(:from, attribute).to_s
            field = field.camelize(:lower) if options.fetch(:camelize, true)
            value = @data.fetch field, options[:default]
            value = type_cast value, options[:type] if options[:type]
            block_given? ? instance_exec(value, &block) : value
          end
        end

      private

        # A wrapper around Ruby’s +define_method+ that, in addition to adding an
        # instance method called +name+, adds an instance variable called +@name+
        # that stores the result of +name+ the first time is invoked, and returns
        # it every other time. Especially useful if invoking +name+ takes a long
        # time.
        def define_memoized_method(name, &method)
          ivar_name = "@#{name.to_s.gsub /[?!]$/, ''}"

          define_method name do
            value = instance_variable_get ivar_name
            instance_variable_set ivar_name, value || instance_eval(&method)
          end
        end
      end
    end
  end
end
