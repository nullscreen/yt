module Yt
  module Models
    # Encapsulates information about the privacy status of a resource, for
    # instance a channel.
    # @see https://developers.google.com/youtube/v3/docs/channels#resource
    class Status
      def initialize(options = {})
        @data = options[:data]
      end

# Privacy status

      PRIVACY_STATUSES = %q(private public unlisted)

      # @return [String] the privacy status of the resource. Valid values are:
      #   private, public, unlisted.
      def privacy_status
        @privacy_status ||= @data['privacyStatus']
      end

      # @return [Boolean] whether the resource is public.
      def public?
        privacy_status == 'public'
      end

      # @return [Boolean] whether the resource is private.
      def private?
        privacy_status == 'private'
      end

      # @return [Boolean] whether the resource is unlisted.
      def unlisted?
        privacy_status == 'unlisted'
      end
    end
  end
end