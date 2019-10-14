require 'yt/models/base'
require 'yt/models/asset_metadata'

module Yt
  module Models
    # Provides methods to interact with YouTube ContentID assets.
    # @see https://developers.google.com/youtube/partner/docs/v1/assets
    class Asset < Base
      attr_reader :auth

      def initialize(options = {})
        @data = options.fetch(:data, {})
        @id = options[:id]
        @auth = options[:auth]
        @params = options[:params]
      end

      def update(attributes = {})
        underscore_keys! attributes
        do_update body: attributes
        true
      end

      # @!attribute [r] ownership
      #   @return [Yt::Models::Ownership] the asset’s ownership.
      has_one :ownership
      delegate :general_owners, :performance_owners, :synchronization_owners,
        :mechanical_owners, to: :ownership

      def metadata_mine
        @metadata_mine ||= Yt::Models::AssetMetadata.new data: @data.fetch('metadataMine', {})
      end

      def metadata_effective
        @metadata_effective ||= Yt::Models::AssetMetadata.new data: @data.fetch('metadataEffective', {})
      end

      def ownership_effective
        @ownership_effective ||= Yt::Models::Ownership.new data: @data.fetch('ownershipEffective', {})
      end

      # Soft-deletes the asset.
      # @note YouTube API does not provide a +delete+ method for the Asset
      #   resource, but only an +update+ method. Updating the +status+ of a
      #   Asset to "inactive" can be considered a soft-deletion.
      # @note Despite what the documentation says, YouTube API never returns
      #   the status of an asset, so it’s impossible to update, although the
      #   documentation says this should be the case. If YouTube ever fixes
      #   the API, then the following code can be uncommented.
      # @return [Boolean] whether the asset is inactive.
      # def delete
      #   body = {id: id, status: :inactive}
      #   do_patch(body: body) {|data| @data = data}
      #   inactive?
      # end

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

      # @return [Array<String>] the list of asset labels associated
      #   with the asset. You can apply a label to multiple assets to group
      #   them. You can use the labels as search filters to perform bulk updates,
      #   to download reports, or to filter YouTube Analytics.
      has_attribute :label, default: []

# Status

      # Returns the asset’s status.
      # @return [String] the asset’s status. Possible values are: +'active'+,
      #   +'inactive'+, +'pending'+.
      # @note Despite what the documentation says, YouTube API never returns
      #   the status of an asset, so it’s impossible to update, although the
      #   documentation says this should be the case. If YouTube ever fixes
      #   the API, then the following code can be uncommented.
      # has_attribute :status
      #
      # # @return [Boolean] whether the asset is active.
      # def active?
      #   status == 'active'
      # end
      #
      # # @return [Boolean] whether the asset is inactive.
      # def inactive?
      #   status == 'inactive'
      # end
      #
      # # @return [Boolean] whether the asset is pending.
      # def pending?
      #   status == 'pending'
      # end

    private

      # @see https://developers.google.com/youtube/partner/docs/v1/assets/patch
      def patch_params
        super.tap do |params|
          params[:expected_response] = Net::HTTPOK
          params[:path] = "/youtube/partner/v1/assets/#{@id}"
          params[:params] = {on_behalf_of_content_owner: @auth.owner_name}
        end
      end

      # @see https://developers.google.com/youtube/partner/docs/v1/assets/update
      def update_params
        super.tap do |params|
          params[:expected_response] = Net::HTTPOK
          params[:path] = "/youtube/partner/v1/assets/#{@id}"
          params[:params] = {on_behalf_of_content_owner: @auth.owner_name}
        end
      end

      # @return [Hash] the parameters to submit to YouTube to get an asset.
      # @see https://developers.google.com/youtube/partner/docs/v1/assets/get
      def get_params
        super.tap do |params|
          params[:path] = "/youtube/partner/v1/assets/#{@id}"
          params[:params] = {on_behalf_of_content_owner: @auth.owner_name}.merge! @params
        end
      end
    end
  end
end
