require 'yt/models/base'

module Yt
  module Models
    # Provides methods to interact with YouTube ContentID assetSnippets.
    # @see https://developers.google.com/youtube/partner/docs/v1/assetSearch
    class AssetSnippet < Base
      attr_reader :auth

      def initialize(options = {})
        @data = options.fetch(:data, {})
        @auth = options[:auth]
      end

      # @return [String] the ID that YouTube assigns and uses to uniquely
      #   identify the asset.
      has_attribute :id

      # Returns the asset’s type.
      # @return [String] the asset’s type. This value determines the metadata
      #   fields that you can set for the asset. In addition, certain API
      #   functions may only be supported for specific types of assets. For
      #   example, composition assets may have more complex ownership data than
      #   other types of assets.
      #   Possible values are: +'art_track_video'+, +'composition'+,
      #   +'episode'+, +'general'+, +'movie'+, +'music_video'+, +'season'+,
      #   +'show'+, +'sound_recording'+, +'video_game'+, +'web'+.
      has_attribute :type

      # @return [String] the title of this asset.
      has_attribute :title

      # @return [String] the Custom ID assigned by the content owner to
      #   this asset.
      has_attribute :custom_id

      # @return [String] the ISRC (International Standard Recording Code)
      #   for this asset.
      has_attribute :isrc

      # @return [String] the ISWC (International Standard Musical Work Code)
      #   for this asset.
      has_attribute :iswc
    end
  end
end