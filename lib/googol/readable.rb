module Googol
  # Provides methods to read attributes for public objects (accounts, videos..)
  module Readable

    # Return the unique Youtube identifier of a Youtube object
    def id
      info[:id]
    end

    # Return the title of a Youtube object
    def title
      info[:snippet][:title]
    end

    # Return the description of a Youtube object
    def description
      info[:snippet][:description]
    end

    # Return the URL of the thumbnail image of the Youtube channel/videp.
    #
    # @option size [Symbol] :default The size of the thumbnail. Valid values are:
    #                       :default (channel: 88px x 88px, video: 120px x 90px)
    #                       :medium (channel: 240px x 240px, video: 320px x 180px)
    #                       :high (channel: 800px x 800px, video: 480px x 360px)
    #
    # @return [String] The thumbnail URL
    def thumbnail_url(size = :default)
      size = :default unless [:medium, :high].include? size
      info[:snippet][:thumbnails][size][:url]
    end

    # Return the kind of the Youtube object (either 'channel' or 'video')
    def kind
      info.fetch(:kind, '').split("#").last
    end
  end
end