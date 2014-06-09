require 'yt/models/resource'
require 'yt/associations/earnings'
require 'yt/associations/views'

module Yt
  module Models
    class Channel < Resource
      include Associations::Earnings
      include Associations::Views

      has_many :subscriptions
      has_many :videos
      has_many :playlists

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

      def create_playlist(params = {})
        playlists.insert params
      end

      def delete_playlists(attrs = {})
        playlists.delete_all attrs
      end
    end
  end
end