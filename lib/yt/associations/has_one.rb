module Yt
  module Associations
    # @private
    # Associations are a set of macro-like class methods to express
    # relationship between YouTube resources like "Channel has many Videos" or
    # "Account has one Id". They are inspired by ActiveRecord::Associations.
    module HasOne
      # @example Adds the +status+ method to the Video resource.
      #   class Video < Resource
      #     has_one :status
      #   end
      def has_one(attribute)
        require 'yt/associations/has_many'
        extend Associations::HasMany

        attributes = attribute.to_s.pluralize
        has_many attributes
        define_memoized_method(attribute) { send(attributes).first! }
      end
    end
  end
end