require 'yt/errors/request_error'

module Yt
  module Errors
    class ServerError < RequestError
      def explanation
        'A request to YouTube API caused an unexpected server error'
      end
    end
  end
end
