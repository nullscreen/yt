require 'yt/models/base'

module Yt
  module Models
    # Encapsulates basic information about the video file itself,
    # including the file name, size, type, and container.
    # @see https://developers.google.com/youtube/v3/docs/videos#resource
    class FileDetail < Base

      def initialize(options = {})
        @data = options[:data]
      end

      # @return [String] the file name of the video.
      has_attribute :file_name

      # @return [Integer] the file size of the video (in bytes).
      has_attribute :file_size, type: Integer

      # @return [String] the file type of the file. May be one of:
      #   archive, audio, document, image, other, project, or video.
      has_attribute :file_type

      # @return [String] the container of the video (e.g. 'mov').
      has_attribute :container
    end
  end
end
