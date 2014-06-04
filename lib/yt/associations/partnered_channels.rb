require 'yt/collections/partnered_channels'

module Yt
  module Associations
    # Provides the `has_many :partnered_channels` method to YouTube resources,
    # which allows to access to partnered channel-specific methods.
    # YouTube resources with a channel are: content owners.
    module PartneredChannels
      def partnered_channels
        @partnered_channels ||= Collections::PartneredChannels.of self
      end
    end
  end
end