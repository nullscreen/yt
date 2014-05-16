require 'yt/models/base'
require 'yt/models/url'

module Yt
  class Resource < Base
    attr_reader :auth
    has_one :id
    has_one :snippet, delegate: [:title, :description, :thumbnail_url, :published_at, :tags]
    has_one :status, delegate: [:privacy_status, :public?, :private?, :unlisted?]

    def initialize(options = {})
      @url = URL.new(options[:url]) if options[:url]
      @id = options[:id] || (@url.id if @url)
      @auth = options[:auth]
      @snippet = Snippet.new(data: options[:snippet]) if options[:snippet]
      @status = Status.new(data: options[:status]) if options[:status]
    end

    def kind
      @url ? @url.kind.to_s : self.class.to_s.demodulize.underscore
    end

    def username
      @url.username if @url
    end
  end
end