# encoding: UTF-8

require 'yt/models/base'

module Yt
  module Models
    class Resource < Base
      # @private
      attr_reader :auth

    ### ID ###

      # @!attribute [r] id
      #   @return [String] the ID that YouTube uses to identify each resource.
      attr_reader :id

    ### STATUS ###

      has_one :status

      # @!attribute [r] privacy_status
      #   @return [String] the privacy status of the resource. Possible values
      #     are: +'private'+, +'public'+, +'unlisted'+.
      delegate :privacy_status, to: :status

      # @return [Boolean] whether the resource is public.
      def public?
        privacy_status == 'public'
      end

      # @return [Boolean] whether the resource is private.
      def private?
        privacy_status == 'private'
      end

      # @return [Boolean] whether the resource is unlisted.
      def unlisted?
        privacy_status == 'unlisted'
      end

      has_one :snippet

      # @private
      def initialize(options = {})
        @id = options[:id]
        @auth = options[:auth]
        @snippet = Snippet.new(data: options[:snippet]) if options[:snippet]
        @status = Status.new(data: options[:status]) if options[:status]
      end

      # @private
      def kind
        self.class.to_s.demodulize.underscore
      end

      # @private
      def update(attributes = {})
        underscore_keys! attributes
        body = build_update_body attributes
        params = {part: body.keys.join(',')}
        do_update params: params, body: body.merge(id: @id) do |data|
          @id = data['id']
          @snippet = Snippet.new data: data['snippet'] if data['snippet']
          @status = Status.new data: data['status'] if data['status']
          true
        end
      end

    private

      # Since YouTube API only returns tags on Videos#list, the memoized
      # `@snippet` is erased if the video was instantiated through Video#search
      # (e.g., by calling account.videos or channel.videos), so that the full
      # snippet (with tags and category) is loaded, rather than the partial one.
      def ensure_complete_snippet(attribute)
        unless snippet.public_send(attribute).present? || snippet.complete?
          @snippet = nil
        end
        snippet.public_send attribute
      end

      # TODO: instead of having Video, Playlist etc override this method,
      #       they should define *what* can be updated in their own *update*
      #       method.
      # @return [Hash] the parameters to submit to YouTube to update a playlist.
      # @see https://developers.google.com/youtube/v3/docs/playlists/update
      # @see https://developers.google.com/youtube/v3/docs/videos/update
      def update_params
        super.tap do |params|
          params[:request_format] = :json
          params[:expected_response] = Net::HTTPOK
        end
      end

      # @return [Hash] the parameters to submit to YouTube to delete a playlist.
      # @see https://developers.google.com/youtube/v3/docs/playlists/delete
      def delete_params
        super.tap{|params| params[:params] = {id: @id}}
      end

      def build_update_body(attributes = {})
        {}.tap do |body|
          update_parts.each do |name, part|
            if should_include_part_in_update? part, attributes
              body[name] = build_update_body_part name, part, attributes
              sanitize_brackets! body[name] if part[:sanitize_brackets]
            end
          end
        end
      end

      def build_update_body_part(name, part, attributes = {})
        {}.tap do |body_part|
          part[:keys].map do |key|
            body_part[camelize key] = attributes.fetch key, public_send(name).public_send(key)
          end
        end
      end

      def should_include_part_in_update?(part, attributes = {})
        part[:required] || (part[:keys] & attributes.keys).any?
      end

      def camelize(value)
        value.to_s.camelize(:lower).to_sym
      end
    end
  end
end