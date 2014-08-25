# encoding: UTF-8

require 'yt/models/base'
require 'yt/models/url'

module Yt
  module Models
    class Resource < Base
      attr_reader :auth
      has_one :id

      has_one :snippet
      delegate :title, :description, :thumbnail_url, :published_at,
        to: :snippet

      has_one :status
      delegate :privacy_status, :public?, :private?, :unlisted?, to: :status

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

      # @return [Hash] the parameters to submit to YouTube to update a playlist.
      # @see https://developers.google.com/youtube/v3/docs/playlists/update
      # @see https://developers.google.com/youtube/v3/docs/videos/update
      def update_params
        super.tap do |params|
          params[:body_type] = :json
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
              body[name] = build_update_body_part part, attributes
              sanitize_brackets! body[name] if part[:sanitize_brackets]
            end
          end
        end
      end

      def build_update_body_part(part, attributes = {})
        {}.tap do |body_part|
          part[:keys].map do |key|
            body_part[camelize key] = attributes.fetch key, send(key)
          end
        end
      end

      def should_include_part_in_update?(part, attributes = {})
        part[:required] || (part[:keys] & attributes.keys).any?
      end

      # @return [Hash] the original hash with angle brackets characters in its
      #   values replaced with similar Unicode characters accepted by Youtube.
      # @see https://support.google.com/youtube/answer/57404?hl=en
      def sanitize_brackets!(source)
        case source
          when String then source.gsub('<', '‹').gsub('>', '›')
          when Array then source.map{|string| sanitize_brackets! string}
          when Hash then source.each{|k,v| source[k] = sanitize_brackets! v}
        end
      end

      def camelize(value)
        value.to_s.camelize(:lower).to_sym
      end
    end
  end
end