require 'yt/collections/base'
require 'yt/models/snippet'

module Yt
  module Collections
    class Snippets < Base

      def initialize(options = {})
        @resource = options[:resource]
        @auth = options[:auth]
      end

      # @note Google API must have some caching layer by which if we try to
      # delete a snippet that we just created, we encounter an error.
      # To overcome this, if we have just updated the snippet, we must
      # wait some time before requesting it again.
      #
      def self.by_resource(resource)
        new resource: resource, auth: resource.auth
      end

    private

      def new_item(data)
        Yt::Snippet.new data: data['snippet']
      end

      def list_params
        resources_path = @resource.class.to_s.demodulize.underscore.pluralize
        super.tap do |params|
          params[:params] = {id: @resource.id, part: 'snippet'}
          params[:scope] = 'https://www.googleapis.com/auth/youtube.readonly'
          params[:path] = "/youtube/v3/#{resources_path}"
        end
      end
    end
  end
end