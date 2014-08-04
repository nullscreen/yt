require 'yt/models/base'

module Yt
  module Models
    # Encapsulates channel data that is relevant for YouTube Partners linked
    # with the channel.
    # @see https://developers.google.com/youtube/v3/docs/channels#contentOwnerDetails
    class ContentOwnerDetail < Base
      def initialize(options = {})
        @data = options[:data] || {}
      end

      # Returns the name of the content owner linked to the channel.
      #
      # This method requires {Resource#auth auth} to return an authenticated
      # instance of {Yt::ContentOwner} that can administer the channel.
      # @return [String] if the channel is partnered with a content owner,
      #   the name of the content owner linked to the channel.
      # @return [nil] if the channel is not partnered with a content owner.
      # @return [nil] if {Resource#auth auth} is a content owner without
      #   permissions to administer the channel.
      # @raise [Yt::Errors::Forbidden] if {Resource#auth auth} does not
      #   return an authenticated content owner.
      def content_owner
        @content_owner ||= @data['contentOwner']
      end

      # Returns the date and time of when the channel was linked to the content
      # owner.
      #
      # This method requires {Resource#auth auth} to return an authenticated
      # instance of {Yt::ContentOwner} that can administer the channel.
      # @return [Time] if the channel is partnered with a content owner,
      #   the date and time when the channel was linked with the content owner.
      # @return [nil] if the channel is not partnered with a content owner.
      # @return [nil] if {Resource#auth auth} is a content owner without
      #   permissions to administer the channel.
      # @raise [Yt::Errors::Forbidden] if {Resource#auth auth} does not
      #   return an authenticated content owner.
      def linked_at
        @linked_at ||= if @data['timeLinked']
          Time.parse @data['timeLinked']
        end
      end
    end
  end
end