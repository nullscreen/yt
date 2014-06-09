require 'yt/collections/subscriptions'

module Yt
  module Associations
    # Provides the `has_one :subscription` method to YouTube resources, which
    # allows to invoke subscription-related methods, such as .subscribe.
    # YouTube resources with subscription are: channels.
    module Subscriptions
      def subscriptions
        @subscriptions ||= Collections::Subscriptions.of self
      end
    end
  end
end