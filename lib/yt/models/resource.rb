require 'yt/models/base'

module Yt
  class Resource < Base
    attr_reader :id, :auth
    has_one :snippet, delegate: [:title, :description, :thumbnail_url, :published_at, :tags]
    has_one :status, delegate: [:privacy_status, :public?, :private?, :unlisted?]

    def initialize(options = {})
      @id = options[:id]
      @auth = options[:auth]
      @snippet = Snippet.new(data: options[:snippet]) if options[:snippet]
      @status = Status.new(data: options[:status]) if options[:status]
    end
  end
end