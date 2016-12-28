require 'yt/errors/request_error'

module Yt
  module Errors
    class Forbidden < RequestError
      def explanation
        'A request to YouTube API was considered forbidden by the server'
      end
    end
  end
end
