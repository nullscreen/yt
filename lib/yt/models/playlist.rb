require 'yt/models/base'

module Yt
  class Playlist < Base
    attr_reader :id, :auth
    has_one :snippet, delegate: [:title, :description, :tags, :thumbnail_url, :published_at]
    has_one :status, delegate: [:privacy_status, :public?, :private?, :unlisted?]
    has_many :playlist_items

    def initialize(options = {})
      @id = options[:id]
      @snippet = Snippet.new(data: options[:snippet]) if options[:snippet]
      @status = Status.new(data: options[:status]) if options[:status]
      @auth = options[:auth]
    end

    def delete
      do_delete {@id = nil}
      !exists?
    end

    # Valid body (no defaults) are: title (string), description (string), privacy_status (string),
    # tags (array of strings) - since title is required, we set it again if it's not passed
    def update(options = {})
      parts, body = [], {id: @id}

      options[:title] ||= title
      parts << :snippet
      body[:snippet] = options.slice :title, :description, :tags

      if status = options[:privacy_status]
        parts << :status
        body[:status] = {privacyStatus: status}
      end

      params = {params: {part: parts.join(',')}, body: body}
      do_update(params, expect: Net::HTTPOK) do |data|
        @id = data['id']
        @snippet = Snippet.new data: data['snippet'] if data['snippet']
        @status = Status.new data: data['status'] if data['status']
        true
      end
    end

    def exists?
      !@id.nil?
    end

  private

    def delete_params
      super.tap do |params|
        params[:path] = '/youtube/v3/playlists'
        params[:params] = {id: @id}
      end
    end

    def update_params
      super.tap do |params|
        params[:path] = '/youtube/v3/playlists'
        params[:body_type] = :json
      end
    end
  end
end