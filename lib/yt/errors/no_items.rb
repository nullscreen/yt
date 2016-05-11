require 'yt/errors/request_error'

module Yt
  module Errors
    class NoItems < RequestError
      def explanation
        'A request to YouTube API returned no items but some were expected'
      end
    end
  end
end
