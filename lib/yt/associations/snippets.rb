require 'yt/collections/snippets'

module Yt
  module Associations
    # Provides the `has_one :snippet` method to YouTube resources, which
    # allows to access to content detail set-specific methods like `title`.
    # YouTube resources with content details are: videos and channels.
    module Snippets
      def snippet
        @snippet ||= snippets.first!
      end

    private

      def snippets
        @snippets ||= Collections::Snippets.of self
      end
    end
  end
end