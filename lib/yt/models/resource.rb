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
    end
  end
end