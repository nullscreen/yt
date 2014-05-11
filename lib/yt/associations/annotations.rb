require 'yt/collections/annotations'

module Yt
  module Associations
    # Provides the `has_many :annotations` method to YouTube resources,
    # which allows to access to content annotation set-specific methods.
    # YouTube resources with annotations are: videos.
    module Annotations
      def annotations
        @annotations ||= Collections::Annotations.of self
      end
    end
  end
end

