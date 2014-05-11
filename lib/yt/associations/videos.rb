require 'yt/collections/videos'

module Yt
  module Associations
    # Provides the `has_many :videos` method to YouTube resources, which
    # allows to access only the videos that belong to a specific resource.
    # YouTube resources with videos are: channels.
    module Videos
      def videos
        @videos ||= Collections::Videos.of self
      end
    end
  end
end