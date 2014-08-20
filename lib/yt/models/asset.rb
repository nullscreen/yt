require 'yt/models/base'

module Yt
  module Models
    # Provides methods to interact with YouTube ContentID assets.
    # @see https://developers.google.com/youtube/partner/docs/v1/assets
    class Asset < Base
      def initialize(options = {})
        @data = options[:data]
      end

      # @return [String] the ID that YouTube assigns and uses to uniquely
      #   identify the asset.
      def id
        @id ||= @data['id']
      end

      # @return [String] The asset's type. This value determines which 
      # metadata fields might be included in the metadata object.
      def type
        @type ||= @data['type']
      end

      # @return [String] Title of this asset.
      def title
        @title ||= @data.fetch "title", nil
        @title ||= metadata ? metadata.fetch('title', nil) : nil
      end

      # @return [String] Title of this asset.
      def customId
        @customId ||= @data.fetch "customId", nil
        @customId ||= metadata ? metadata.fetch('customId', nil) : nil
      end

    private 
      # @return [Hash] the metadata associated with the asset.
      def metadata
        @metadata ||= @data.fetch "metadata", nil
      end

    end
  end
end