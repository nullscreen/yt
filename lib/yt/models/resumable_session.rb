require 'cgi'
require 'yt/models/base'

module Yt
  module Models
    # Provides methods to upload videos with the resumable upload protocol.
    # @see https://developers.google.com/youtube/v3/guides/using_resumable_upload_protocol
    class ResumableSession < Base
      # Sets up a resumable session using the URI returned by YouTube
      def initialize(options = {})
        @uri = URI.parse options[:url]
        @auth = options[:auth]
        @headers = options[:headers]
      end

      # Uploads a video using the current resumable session
      # @param [#read] file A binary object that contains the video content.
      #   Can either be a File, a StringIO (for instance using open-uri), etc.
      # @return [Yt::Models::Video] the newly uploaded video.
      def upload_video(file)
        do_update(body: file) do |data|
          Yt::Video.new id: data['id'], snippet: data['snippet'], status: data['privacyStatus'], auth: @auth
        end
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