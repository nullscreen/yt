require 'yt/models/resource'

module Yt
  module Models
    # Provides methods to interact with YouTube commentThreads.
    # @see https://developers.google.com/youtube/v3/docs/commentThreads
    class CommentThread < Resource

    ### SNIPPET ###

      # @!attribute [r] channel_id
      #   @return [String] the ID of the channel that the thread belongs to.
      delegate :channel_id, to: :snippet

      # @!attribute [r] video_id
      #   @return [String] the ID of the video that the thread belongs to.
      delegate :video_id, to: :snippet


      def top_level_comment
        @subject_comment
      end
      alias :comment :top_level_comment

    ### PRIVATE API ###

      # @private
      # Override Resource's new to set replies if the response includes them
      # @todo Handle replies
      def initialize(options = {})
        super options
        if options[:top_level_comment]
          @subject_comment = Comment.new(snippet: options[:top_level_comment].delete('snippet'), data: options[:top_level_comment])
        end
        if options[:replies]
          # @replies = CommentSet.new data: options[:replies]
        end
      end

    end

  end
end
