module Yt
  class Video < Base
    has_many :annotations
    has_one :details_set, delegate: [:duration]
    has_one :rating
    has_one :snippet, delegate: [:title, :description, :tags, :thumbnail_url, :published_at]

    attr_reader :id, :auth

    def initialize(options = {})
      @id = options[:id]
      @auth = options[:auth]
      @snippet = Snippet.new(data: options[:snippet]) if options[:snippet]
    end
  end
end