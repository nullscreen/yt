require 'cgi'
require 'yt/models/base'

module Yt
  module Models
    # @private
    # Provides methods to upload videos with the resumable upload protocol.
    # @see https://developers.google.com/youtube/v3/guides/using_resumable_upload_protocol
    class ResumableSession < Base
      # Sets up a resumable session using the URI returned by YouTube
      def initialize(options = {})
        @uri = URI.parse options[:url]
        @auth = options[:auth]
        @headers = options[:headers]
      end

      def update(params = {})
        do_update(params) {|data| yield data}
      end

      # Uploads a thumbnail using the current resumable session
      # @param [#read] file A binary object that contains the image content.
      #   Can either be a File, a StringIO (for instance using open-uri), etc.
      # @return the new thumbnail resource for the given image.
      # @see https://developers.google.com/youtube/v3/docs/thumbnails#resource
      def upload_thumbnail(file)
        do_update(body: file) {|data| data['items'].first}
      end

    private

      def session_params
        CGI::parse(@uri.query).tap{|hash| hash.each{|k,v| hash[k] = v.first}}
      end

      # @note: YouTube documentation states that a valid upload returns an HTTP
      #   code of 201 Created -- however it looks like the actual code is 200.
      #   To be sure to include both cases, HTTPSuccess is used
      def update_params
        super.tap do |params|
          params[:request_format] = :file
          params[:host] = @uri.host
          params[:path] = @uri.path
          params[:expected_response] = Net::HTTPSuccess
          params[:headers] = @headers
          params[:camelize_params] = false
          params[:params] = session_params
        end
      end
    end
  end
end