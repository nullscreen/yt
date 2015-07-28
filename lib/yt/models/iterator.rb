module Yt
  module Models
    # @private
    # If we dropped support for Ruby 1.9.3, then we could simply use Enumerator
    # which takes a `size` parameter in Ruby >= 2.
    class Iterator < Enumerator
      def initialize(size=nil, &block)
        RUBY_VERSION < '2' ? super(&block) : super(size, &block)
      end

      def size
        RUBY_VERSION < '2' ? count : super
      end
    end
  end
end