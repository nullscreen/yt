# encoding: UTF-8
require 'yt/collections/base'

module Yt
  module Collections
    class Resources < Base
      def delete_all(params = {})
        do_delete_all params
      end

      def insert(attributes = {}, options = {}) #
        underscore_keys! attributes
        body = build_insert_body attributes
        params = {part: body.keys.join(',')}
        do_insert(params: params, body: body)
      end

    private

      # @return [resource_class] a new resource item initialized with
      #   one of the items returned by asking YouTube for a list of items.
      # @see https://developers.google.com/youtube/v3/docs/playlistItems#resource
      # @see https://developers.google.com/youtube/v3/docs/playlists#resource
      # @see https://developers.google.com/youtube/v3/docs/channels#resource
      def new_item(data)
        resource_class.new id: data['id'], snippet: data['snippet'], status: data['status'], auth: @auth
      end

      def resources_params
        {max_results: 50, part: 'snippet,status'}
      end

      def resource_class
        resource_name = list_resources.name.demodulize.singularize
        require "yt/models/#{resource_name.underscore}"
        "Yt::Models::#{resource_name}".constantize
      end

      def build_insert_body(attributes = {})
        {}.tap do |body|
          insert_parts.each do |name, part|
            if should_include_part_in_insert? part, attributes
              body[name] = build_insert_body_part part, attributes
              sanitize_brackets! body[name] if part[:sanitize_brackets]
            end
          end
        end
      end

      def build_insert_body_part(part, attributes = {})
        {}.tap do |body_part|
          part[:keys].map do |key|
            body_part[camelize key] = attributes[key]
          end
        end
      end

      def should_include_part_in_insert?(part, attributes = {})
        (part[:keys] & attributes.keys).any?
      end

      def camelize(value)
        value.to_s.camelize(:lower).to_sym
      end
    end
  end
end