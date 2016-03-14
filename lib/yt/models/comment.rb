require 'yt/models/resource'

module Yt
  module Models
    # Provides methods to interact with YouTube commentThreads.
    # @see https://developers.google.com/youtube/v3/docs/commentThreads
    class Comment < Resource

    ### SNIPPET ###

      # @!attribute [r] channel_id
      #   @return [String] the ID of the channel that the comment belongs to.
      delegate :channel_id, to: :snippet

      # @!attribute [r] video_id
      #   @return [String] the ID of the video that the comment belongs to.
      delegate :video_id, to: :snippet

      # @!attribute [r] published_at
      #   @return [Time] the date and time that the comment was posted.
      delegate :updated_at, to: :snippet

      # @!attribute [r] published_at
      #   @return [Time] the date and time that the comment was posted.
      delegate :published_at, to: :snippet

    ### ATTRIBUTES ###

      has_attribute :text_display

      has_attribute :author_display_name

      has_attribute :like_count

      has_attribute :author_profile_image_url

    ### PRIVATE API ###
      def initialize(options = {})
        @data = options[:data] || {}
        if options[:snippet]
          @data['textDisplay'] = options[:snippet]['textDisplay']
          @data['authorDisplayName'] = options[:snippet]['authorDisplayName']
          @data['authorProfileImageUrl'] = options[:snippet]['authorProfileImageUrl']
          @data['likeCount'] = options[:snippet]['likeCount']
        end
        super options
      end

    end

  end
end
