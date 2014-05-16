require 'yt/collections/details_sets'

module Yt
  module Associations
    # Provides the `has_one :details_set` method to YouTube resources, which
    # allows to access to content detail set-specific methods like `duration`.
    # YouTube resources with content details are: videos.
    module DetailsSets
      def details_set
        @detail_set ||= details_sets.first!
      end

    private

      def details_sets
        @details_sets ||= Collections::DetailsSets.of self
      end
    end
  end
end