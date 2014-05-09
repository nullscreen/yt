require 'yt/models/description'

module Yt
  class Snippet
    def initialize(options = {})
      @data = options[:data]
    end

    # Return the title of the YouTube resource.
    #
    # @return [String] Title of the YouTube resource
    def title
      @title ||= @data.fetch 'title', ''
    end

    # Return the description of a YouTube resource.
    #
    # @return [Yt::Description] A Yt::Description object for the YouTube resource
    def description
      @description ||= Description.new @data.fetch('description', '')
    end

    # Return the publication date of a YouTube resource.
    #
    # @return [Time or nil] The publication date for the YouTube resource
    def published_at
      @published_at ||= Time.parse @data['publishedAt']
    end

    # Return the tags of a YouTube resource.
    #
    # @return [Array] An array of Yt::Tag object, one for each tag of the resource.
    #
    # @note YouTube API only includes tags in a resource’s snippet if the
    #       resource is a video belonging to the authenticated account.
    def tags
      @tags ||= @data.fetch 'tags', []
    end

    # Return the URL of a thumbnail image of the YouTube resource.
    #
    # @return [String] A URL.
    def thumbnail_url(size = :default)
      @thumbnails ||= @data.fetch 'thumbnails', {}
      @thumbnails.fetch(size.to_s, {})['url']
    end
  end
end