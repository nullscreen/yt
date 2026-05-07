require 'json'
require 'yt/models/base'
require 'yt/actions/upload'

module Yt
  module Models
    # @private
    # Provides methods to upload videos with the resumable upload protocol.
    # @see https://developers.google.com/youtube/v3/guides/using_resumable_upload_protocol
    class ResumableSession < Base
      include Actions::Upload

      # Sets up a resumable session using the URI returned by YouTube
      def initialize(options = {})
        @uri = URI.parse options[:url]
        @auth = options[:auth]
        @headers = options[:headers]
      end

      def upload(params = {})
        body = params[:body]
        do_upload headers: upload_headers(body), body: body do |response|
          yield JSON.parse(response.body)
        end
      end

      # Uploads a thumbnail using the current resumable session
      # @param [#read] file A binary object that contains the image content.
      #   Can either be a File, a StringIO (for instance using open-uri), etc.
      # @return the new thumbnail resource for the given image.
      # @see https://developers.google.com/youtube/v3/docs/thumbnails#resource
      def upload_thumbnail(file)
        do_upload headers: upload_headers(file), body: file do |response|
          data = JSON.parse(response.body)
          data['items'].first
        end
      end

      private

      def upload_params
        { uri: @uri, token: @auth.access_token }
      end

      def upload_headers(body)
        @headers.merge('Content-Length' => body.size.to_s)
      end
    end
  end
end
