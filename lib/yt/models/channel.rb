require 'yt/models/base'

module Yt
  class Channel < Base
    attr_reader :id, :auth
    has_one :snippet, delegate: [:title, :description, :thumbnail_url, :published_at]
    has_many :subscriptions
    has_many :videos
    has_many :playlists

    def initialize(options = {})
      @id = options[:id]
      @auth = options[:auth]
      @snippet = Snippet.new(data: options[:snippet]) if options[:snippet]
    end
  end
end