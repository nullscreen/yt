require 'yt/models/base'

module Yt
  module Models
    # @private
    # Encapsulates basic information about the video file itself,
    # including the file name, size, type, and container.
    # @see https://developers.google.com/youtube/v3/docs/videos#fileDetails
    class FileDetail < Base
      attr_reader :data

      def initialize(options = {})
        @data = options[:data] || {}
      end

      has_attribute :file_size, type: Integer
      has_attribute :file_type
      has_attribute :container
    end
  end
end
