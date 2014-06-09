require 'yt/models/resource'

module Yt
  module Models
    class Channel < Resource
      has_many :subscriptions
      has_many :videos
      has_many :playlists
      has_many :earnings
      has_many :views

      def subscribed?
        subscriptions.any?{|s| s.exists?}
      end

      def subscribe
        subscriptions.insert ignore_errors: true
      end

      def subscribe!
        subscriptions.insert
      end

      def unsubscribe
        subscriptions.delete_all({}, ignore_errors: true)
      end

      def unsubscribe!
        subscriptions.delete_all
      end
    end
  end
end