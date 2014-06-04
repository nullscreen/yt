require 'yt/models/account'

module Yt
  module Models
    # Provides methods to access a YouTube content owner.
    class ContentOwner < Account
      has_many :partnered_channels
      attr_reader :owner_name

      def initialize(options = {})
        super options
        @owner_name = options[:owner_name]
      end
    end
  end
end