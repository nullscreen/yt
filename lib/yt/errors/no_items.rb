require 'yt/errors/base'

module Yt
  module Errors
    class NoItems < Base
      def message
        <<-MSG.gsub(/^ {6}/, '')
        A request to YouTube API V3 returned no items (but some were expected):
        #{response_body}

        You can retry the same request manually by running:
        #{request_curl}
        MSG
      end
    end
  end
end