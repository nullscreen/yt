require 'yt/collections/ids'

module Yt
  module Associations
    # Provides the `has_one :id` method to YouTube resources, which
    # allows to retrieve the id of a resource knowing only its username.
    # YouTube resources with ids are: resources.
    module Ids
      def id
        @id ||= ids.first!
      end

    private

      def ids
        @ids ||= Collections::Ids.of self
      end
    end
  end
end