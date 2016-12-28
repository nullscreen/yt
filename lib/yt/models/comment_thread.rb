require 'yt/models/resource'

module Yt
  module Models
    # Provides methods to interact with YouTube comment thread.
    # @see https://developers.google.com/youtube/v3/docs/commentThreads
    class CommentThread < Resource

    ### SNIPPET ###

      # @!attribute [r] video_id
      #   @return [String] the ID of the video that the comment thread referto, if
      #   any. If this property is not present or does not have a value, then the
      #   thread applies to the channel and not to a specific video.
      delegate :video_id, to: :snippet

      # @!attribute [r] total_reply_count
      #   @return [String] The total number of replies that have been submitted 
      #   in response to the top level comment.
      delegate :total_reply_count, to: :snippet

      # @return [Boolean] whether the thread, including all of its comments and
      # comment replies, is visible to all YouTube users.
      delegate :public?, to: :snippet

      # @return [Boolean] whether the current viewer can reply to the thread.
      delegate :can_reply?, to: :snippet

      # @!attribute [r] top_level_comment
      #   @return [Yt::TopLevelComment] the top level comment object.
      delegate :top_level_comment, to: :snippet

      # @!attribute [r] text_display
      #   @return [String] the top level comment's display text.
      delegate :text_display, to: :top_level_comment

      # @!attribute [r] author_display_name
      #   @return [String] the top level comment's author name.
      delegate :author_display_name, to: :top_level_comment

      # @!attribute [r] like_count
      #   @return [String] the top level comment's likes count.
      delegate :like_count, to: :top_level_comment

      # @!attribute [r] updated_at
      #   @return [String] the top level comment's last updated time.
      delegate :updated_at, to: :top_level_comment
    end
  end
end
