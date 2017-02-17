module Yt
  module Models
    # Encapsulates information about the various types of owners of an asset.
    # @see https://developers.google.com/youtube/partner/docs/v1/ownership#resource
    class RightOwner < Base
      def initialize(options = {})
        @data = options[:data]
      end

      # @return [Float] the percentage of the asset that the owner controls or
      #   administers. For composition assets, the value can be any value
      #   between 0 and 100 inclusive. For all other assets, the only valid
      #   values are 100, which indicates that the owner completely owns the
      #   asset in the specified territories, and 0, which indicates that you
      #   are removing ownership of the asset in the specified territories.
      has_attribute :ratio, type: Float

      # @return [String] the name of the asset’s owner or rights administrator.
      has_attribute :owner

      # @return [String] if the asset is a composition asset and the asset
      #   owner is not known to have a formal relationship established with
      #   YouTube, the name of the asset’s publisher or rights administrator.
      # @return [nil] otherwise.
      has_attribute :publisher

      # Return the list of territories where the owner owns the asset.
      # Each territory is an ISO 3166 two-letter country code.
      # @return [Array<String>] if the ownership lists 'included' territories,
      #   the territories where the owner owns the asset.
      # @return [nil] if the ownership does not list 'included' territories,
      def included_territories
        territories if type == 'include'
      end

      # Return the list of territories where the owner does not own the asset.
      # Each territory is an ISO 3166 two-letter country code.
      # @return [Array<String>] if the ownership lists 'excluded' territories,
      #   the territories where the owner does not own the asset.
      # @return [nil] if the ownership does not list 'excluded' territories,
      def excluded_territories
        territories if type == 'exclude'
      end

      # @return [Boolean] whether the ownership applies to the whole world.
      def everywhere?
        excluded_territories == []
      end

    private

      has_attribute :type
      has_attribute :territories, default: []
    end
  end
end