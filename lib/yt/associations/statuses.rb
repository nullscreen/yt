require 'yt/models/status'

module Yt
  module Associations
    # Provides the `has_one :status` method to YouTube resources, which
    # allows to access to status-specific methods like `public?`.
    # YouTube resources with status are: playlists.
    module Statuses
      def status
        @status
      end
    end
  end
end