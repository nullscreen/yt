require 'yt/models/resource'

module Yt
  module Models
    class Video < Resource
      has_one :details_set, delegate: [:duration]
      has_one :rating
      has_many :annotations

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
    end
  end
end