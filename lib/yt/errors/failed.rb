require 'yt/errors/base'

module Yt
  module Errors
    class Failed < Base
      def message
        <<-MSG.gsub(/^ {6}/, '')
        A request to YouTube API V3 failed (code #{response_code}):
        #{response_body}

        You can retry the same request manually by running:
        #{request_curl}
        MSG
      end
    end
  end
end