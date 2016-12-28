module Yt
  module Models
    class GroupInfo < Base
      attr_reader :data

      def initialize(options = {})
        @data = options[:data]['snippet'].merge options[:data]['contentDetails']
        @auth = options[:auth]
      end

      has_attribute :title, default: ''
      has_attribute :item_count, type: Integer
      has_attribute :published_at, type: Time
    end
  end
end