require 'yt/collections/ratings'

module Yt
  module Associations
    # Provides the `has_one :rating` method to YouTube resources, which
    # allows to invoke rating-related methods, such as .like.
    # YouTube resources with rating are: videos.
    module Ratings
      def rating
        @rating ||= ratings.first
      end

      def liked?
        rating.rating == :like
      end

      def like
        rating.update :like
        liked?
      end

      def dislike
        rating.update :dislike
        !liked?
      end

      def unlike
        rating.update :none
        !liked?
      end

    private

      def ratings
        @ratings ||= Collections::Ratings.by_video self
      end
    end
  end
end