require 'yt/models/resource'

module Yt
  module Models
    class Playlist < Resource
      has_many :playlist_items

      def delete
        do_delete {@id = nil}
        !exists?
      end

      def update(options = {})
        options[:title] ||= title
        options[:description] ||= description
        options[:tags] ||= tags
        options[:privacy_status] ||= privacy_status

        snippet = options.slice :title, :description, :tags
        status = {privacyStatus: options[:privacy_status]}
        body = {id: @id, snippet: snippet, status: status}

        do_update(params: {part: 'snippet,status'}, body: body) do |data|
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
          params[:expected_response] = Net::HTTPOK
        end
      end
    end
  end
end