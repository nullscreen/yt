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

      def update(attributes = {}, &block)
        underscore_keys! attributes
        body = build_update_body attributes
        params = {part: body.keys.join(',')}
        do_update(params: params, body: body.merge(id: @id), &block)
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
        body = {}
        update_parts.each do |name, part|
          body[name] = {}.tap do |hash|
            part[:keys].map{|k| hash[camelize k] = attributes.fetch k, send(k)}
          end if should_include_part_in_update?(part, attributes)
        end
        body
      end

      def should_include_part_in_update?(part, attributes = {})
        part[:required] || (part[:keys] & attributes.keys).any?
      end

      # If we dropped support for ActiveSupport 3, then we could simply
      # invoke transform_keys!{|key| key.to_s.underscore.to_sym}
      def underscore_keys!(hash)
        hash.dup.each_key{|key| hash[underscore key] = hash.delete key}
      end

      def camelize(value)
        value.to_s.camelize(:lower).to_sym
      end

      def underscore(value)
        value.to_s.underscore.to_sym
      end
    end
  end
end