module Yt
  module Models
    class Authentication
      attr_reader :access_token, :refresh_token, :expires_at

      def initialize(data = {})
        @access_token = data['access_token']
        @refresh_token = data['refresh_token']
        @expires_at = expiration_date data.slice('expires_at', 'expires_in')
      end

      def expired?
        @expires_at && @expires_at.past?
      end

    private

      def expiration_date(options = {})
        if options['expires_in']
          Time.now + options['expires_in'].seconds
        else
          Time.parse options['expires_at'] rescue nil
        end
      end
    end
  end
end