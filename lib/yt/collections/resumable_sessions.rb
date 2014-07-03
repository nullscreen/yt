require 'yt/collections/base'
require 'yt/models/resumable_session'

module Yt
  module Collections
    # Provides methods to upload videos with the resumable upload protocol.
    #
    # Resources with resumable sessions are: {Yt::Models::Account accounts}.
    #
    # @see https://developers.google.com/youtube/v3/guides/using_resumable_upload_protocol
    class ResumableSessions < Base

      # Starts a resumable session by sending to YouTube the metadata of the
      # video to upload. If the request succeeds, YouTube returns a unique
      # URL to upload the video file (and eventually resume the upload).
      # @param [Integer] content_length the size (bytes) of the video to upload.
      # @param [Hash] params the metadata to add to the uploaded video.
      # @option params [String] :title The video’s title.
      # @option params [String] :description The video’s description.
      # @option params [Array<String>] :title The video’s tags.
      # @option params [String] :privacy_status The video’s privacy status.
      def insert(content_length, options = {})
        @headers = headers_for content_length
        body = {}

        snippet = options.slice :title, :description, :tags
        body[:snippet] = snippet if snippet.any?

        status = options[:privacy_status]
        body[:status] = {privacyStatus: status} if status

        do_insert body: body, headers: @headers
      end

    private

      def new_item(data)
        Yt::ResumableSession.new url: data['Location'], headers: @headers, auth: @auth
      end

      def insert_params
        super.tap do |params|
          params[:format] = nil
          params[:path] = '/upload/youtube/v3/videos'
          params[:params] = {part: 'snippet,status', uploadType: 'resumable'}
        end
      end

      def headers_for(content_length)
        {}.tap do |headers|
          headers['x-upload-content-length'] = content_length
          headers['X-Upload-Content-Type'] = 'video/*'
        end
      end

      # The result is not in the body but in the headers
      def extract_data_from(response)
        response.header
      end
    end
  end
end