module Yt
  module Models
    class Authentication
      attr_reader :access_token, :refresh_token, :expires_at

      def initialize(data = {})
        @access_token = data['access_token']
        @refresh_token = data['refresh_token']
        @expires_at = Time.now + data['expires_in'].seconds
      end
    end
  end
end