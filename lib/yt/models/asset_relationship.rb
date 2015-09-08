require 'yt/models/base'

module Yt
  module Models
    class AssetRelationship < Base
      attr_reader :auth

      def initialize(options = {})
        @data = options.fetch(:data, {})
        @id = options[:id]
        @auth = options[:auth]
      end

      has_attribute :id
    end
  end
end
