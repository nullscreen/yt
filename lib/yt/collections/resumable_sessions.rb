require 'yt/collections/base'
require 'yt/models/resumable_session'

module Yt
  module Collections
    # @private
    # Provides methods to upload videos with the resumable upload protocol.
    #
    # Resources with resumable sessions are: {Yt::Models::Account accounts}.
    #
    # @see https://developers.google.com/youtube/v3/guides/using_resumable_upload_protocol
    class ResumableSessions < Base

      # Starts a resumable session by sending to YouTube the metadata of the
      # object to upload. If the request succeeds, YouTube returns a unique
      # URL to upload the object file (and eventually resume the upload).
      # @param [Integer] content_length the size (bytes) of the object to upload.
      # @param [Hash] body the metadata to add to the uploaded object.
      def insert(content_length, body = {})
        @headers = headers_for content_length
        do_insert body: body, headers: @headers
      end

    private

      def attributes_for_new_item(data)
        {url: data['Location'], headers: @headers, auth: @auth}
      end

      def insert_params
        super.tap do |params|
          params[:response_format] = nil
          params[:path] = @parent.upload_path
          params[:params] = @parent.upload_params.merge uploadType: 'resumable'
        end
      end

      def headers_for(content_length)
        {}.tap do |headers|
          headers['x-upload-content-length'] = content_length
          headers['X-Upload-Content-Type'] = @parent.upload_content_type
        end
      end

      # The result is not in the body but in the headers
      def extract_data_from(response)
        response.header
      end
    end
  end
end