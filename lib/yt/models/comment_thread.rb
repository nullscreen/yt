require 'yt/models/resource'

module Yt
  module Models
    # Provides methods to interact with YouTube channels.
    # @see https://developers.google.com/youtube/v3/docs/commentThreads
    class CommentThread < Resource

    ### SNIPPET ###

      # @!attribute [r] video_id
      #   @return [String] the ID of the video that the comments refer to, if
      #   any. If this property is not present or does not have a value, then
      #   the thread applies to the channel and not to a specific video.
      delegate :video_id, to: :snippet

      # @!attribute [r] total_reply_count
      #   @return [String] The total number of replies that have been submitted 
      #   in response to the top-level comment.
      delegate :total_reply_count, to: :snippet

      # @return [Boolean] whether the thread, including all of its comments and
      # comment replies, is visible to all YouTube users.
      delegate :public?, to: :snippet

      # @return [Boolean] whether the current viewer can reply to the thread.
      delegate :can_reply?, to: :snippet
    end
  end
end
