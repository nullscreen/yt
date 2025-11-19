require 'yt/models/base'

module Yt
  module Models
    class ChannelSection < Base
      attr_reader :data

      # @private
      def initialize(options = {})
        @id = options[:id]
        @data = options[:snippet]
      end

      has_attribute :type
      has_attribute :channel_id
      has_attribute :position, type: Integer

    ### ID ###

      # @!attribute [r] id
      #   @return [String] the ID that YouTube uses to identify each resource.
      attr_reader :id
    end
  end
end
