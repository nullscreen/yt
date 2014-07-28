require 'yt/models/resource'

module Yt
  module Models
    # Provides methods to interact with YouTube playlists.
    # @see https://developers.google.com/youtube/v3/docs/playlists
    class Playlist < Resource
      delegate :tags, :channel_id, :channel_title, to: :snippet

      # @!attribute [r] playlist_items
      #   @return [Yt::Collections::PlaylistItems] the playlist’s items.
      has_many :playlist_items

      # Deletes the playlist.
      #
      # This method requires {Resource#auth auth} to return an authenticated
      # instance of {Yt::Account} with permissions to delete the playlist.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an account with permissions to delete the playlist.
      # @return [Boolean] whether the playlist does not exist anymore.
      def delete(options = {})
        do_delete {@id = nil}
        !exists?
      end

      def update(attributes = {})
        underscore_keys! attributes

        body = {id: @id}.tap do |body|
          update_parts.each do |part, options|
            if (options[:keys] & attributes.keys).any? || options[:required]
              body[part] = {}.tap do |hash|
                options[:keys].map do |key|
                  hash[camelize key] = attributes[key] || send(key)
                end
              end
            end
          end
        end

        part = body.except(:id).keys.join(',')
        do_update(params: {part: part}, body: body) do |data|
          @id = data['id']
          @snippet = Snippet.new data: data['snippet'] if data['snippet']
          @status = Status.new data: data['status'] if data['status']
          true
        end
      end

      def exists?
        !@id.nil?
      end

      # Adds a video to the playlist
      # Does not raise an error if the video cannot be added (e.g., unknown).
      #
      # This method requires {Resource#auth auth} to return an authenticated
      # instance of {Yt::Account} with permissions to update the playlist.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} does not
      #   return an account with permissions to update the playlist.
      # @return [Yt::PlaylistItem] the item added to the playlist.
      def add_video(video_id)
        playlist_items.insert video_params(video_id), ignore_errors: true
      end

      def add_video!(video_id)
        playlist_items.insert video_params(video_id)
      end

      def add_videos(video_ids = [])
        video_ids.map{|video_id| add_video video_id}
      end

      def add_videos!(video_ids = [])
        video_ids.map{|video_id| add_video! video_id}
      end

      def delete_playlist_items(attrs = {})
        playlist_items.delete_all attrs
      end

    private

      # @see https://developers.google.com/youtube/v3/docs/playlists/update
      def update_parts
        snippet = {keys: [:title, :description, :tags], required: true}
        status = {keys: [:privacy_status]}
        {snippet: snippet, status: status}
      end

      # @note If we dropped support for ActiveSupport 3, then we could simply
      # invoke transform_keys!{|key| key.to_s.underscore.to_sym}
      def underscore_keys!(hash)
        hash.dup.each_key do |key|
          hash[key.to_s.underscore.to_sym] = hash.delete key
        end
      end

      def camelize(value)
        value.to_s.camelize(:lower).to_sym
      end

      def video_params(video_id)
        {id: video_id, kind: :video}
      end
    end
  end
end