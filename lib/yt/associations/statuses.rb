require 'yt/collections/statuses'

module Yt
  module Associations
    # Provides the `has_one :status` method to YouTube resources, which
    # allows to access to status-specific methods like `public?`.
    # YouTube resources with status are: playlists.
    module Statuses
      def status
        @status ||= statuses.first!
      end

    private

      def statuses
        @statuses ||= Collections::Statuses.of self
      end
    end
  end
end