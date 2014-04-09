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

    # Return the URL of the Youtube object thumbnail
    def thumbnail_url
      info[:snippet][:thumbnails][:default][:url]
    end

    # Return the kind of the Youtube object (either 'channel' or 'video')
    def kind
      info.fetch(:kind, '').split("#").last
    end
  end
end