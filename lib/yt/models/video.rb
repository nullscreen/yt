require 'yt/models/resource'

module Yt
  module Models
    # Provides methods to interact with YouTube videos.
    # @see https://developers.google.com/youtube/v3/docs/videos
    class Video < Resource
      # @!attribute [r] content_detail
      #   @return [Yt::Models::ContentDetail] the video’s content details.
      has_one :content_detail
      delegate :duration, :hd?, :stereoscopic?, :captioned?, :licensed?,
               to: :content_detail

      # @!attribute [r] rating
      #   @return [Yt::Models::Rating] the video’s rating.
      has_one :rating

      # @!attribute [r] annotations
      #   @return [Yt::Collections::Annotations] the video’s annotations.
      has_many :annotations

      # @!attribute [r] statistics_set
      #   @return [Yt::Models::StatisticsSet] the statistics for the video.
      has_one :statistics_set
      delegate :view_count, :like_count, :dislike_count, :favorite_count,
               :comment_count, to: :statistics_set

      # Returns whether the authenticated account likes the video.
      #
      # This method requires {Resource#auth auth} to return an
      # authenticated instance of {Yt::Account}.
      # @return [Boolean] whether the account likes the video.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an authenticated account.
      def liked?
        rating.rating == :like
      end

      # Likes the video on behalf of the authenticated account.
      #
      # This method requires {Resource#auth auth} to return an
      # authenticated instance of {Yt::Account}.
      # @return [Boolean] whether the account likes the video.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an authenticated account.
      def like
        rating.update :like
        liked?
      end

      # Dislikes the video on behalf of the authenticated account.
      #
      # This method requires {Resource#auth auth} to return an
      # authenticated instance of {Yt::Account}.
      # @return [Boolean] whether the account does not like the video.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an authenticated account.
      def dislike
        rating.update :dislike
        !liked?
      end

      # Resets the rating of the video on behalf of the authenticated account.
      #
      # This method requires {Resource#auth auth} to return an
      # authenticated instance of {Yt::Account}.
      # @return [Boolean] whether the account does not like the video.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an authenticated account.
      def unlike
        rating.update :none
        !liked?
      end
    end
  end
end