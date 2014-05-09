require 'yt/collections/channels'

module Yt
  module Associations
    # Provides the `has_one :channel` method to YouTube resources, which
    # allows to access to channel-specific methods like.
    # YouTube resources with a channel are: account.
    module Channels
      def channel
        @channel ||= channels.first
      end

    private

      def channels
        @channels ||= Collections::Channels.by_account self
      end
    end
  end
end