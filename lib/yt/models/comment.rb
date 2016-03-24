require 'yt/models/resource'

module Yt
  module Models
    # Provides methods to interact with YouTube comment.
    # @see https://developers.google.com/youtube/v3/docs/comments
    class Comment < Resource

    ### SNIPPET ###

      # @!attribute [r] video_id
      #   @return [String] the ID of the video that the comment refers to.
      delegate :video_id, to: :snippet

      # @!attribute [r] author_display_name
      #   @return [String] the display name of the user who posted the comment.
      delegate :author_display_name, to: :snippet

      # @!attribute [r] text_display
      #   @return [String] the comment's text.
      delegate :text_display, to: :snippet

      # @!attribute [r] parent_id
      #   @return [String] the unique ID of the parent comment. This property is only
      #   set if the comment was submitted as a reply to another comment.
      delegate :parent_id, to: :snippet

      # @!attribute [r] like_count
      #   @return [Integer] the total number of likes (positive ratings) the comment has received.
      delegate :like_count, to: :snippet

      # @!attribute [r] updated_at
      #   @return [Time] the date and time when the comment was last updated.
      delegate :updated_at, to: :snippet
    end
  end
end
