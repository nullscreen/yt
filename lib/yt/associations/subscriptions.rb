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

      def subscribed?
        subscriptions.any?{|s| s.exists?}
      end

      def subscribe
        subscriptions.insert ignore_duplicates: true
      end

      def subscribe!
        subscriptions.insert
      end

      def unsubscribe
        subscriptions.delete_all({}, ignore_not_found: true)
      end

      def unsubscribe!
        subscriptions.delete_all
      end
    end
  end
end