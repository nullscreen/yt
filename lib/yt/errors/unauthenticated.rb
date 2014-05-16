require 'yt/errors/base'

module Yt
  module Errors
    class Unauthenticated < Base
      def message
        <<-MSG.gsub(/^ {6}/, '')
        A request to YouTube API V3 was sent without the required authentication:

        #{request_curl}

        In order to perform this request, you need to register your app with
        Google Developers Console (https://console.developers.google.com).

        Make sure your app has access to the Google+ and YouTube APIs.
        Generate a client ID, client secret and server API key, then pass their
        values to Yt. One way of doing this is through an initializer:

        Yt.configure do |config|
          config.client_id = '1234567890.apps.googleusercontent.com'
          config.client_secret = '1234567890'
          config.api_key = '123456789012345678901234567890'
        end

        An alternative (but equivalent) way is throught environment variables:

        export YT_CLIENT_ID="1234567890.apps.googleusercontent.com"
        export YT_CLIENT_SECRET="1234567890"
        export YT_API_KEY="123456789012345678901234567890"
        MSG
      end
    end
  end
end