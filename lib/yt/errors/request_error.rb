module Yt
  module Errors
    class RequestError < StandardError
      def initialize(msg = nil)
        @msg = msg
        super msg
      end

      def message
        <<-MSG.gsub(/^ {8}/, '')
        #{explanation}:
        #{response_body}

        You can retry the same request manually by running:
        #{request_curl}
        #{more_details}
        MSG
      end

      def kind
        response_body.fetch 'error', {}
      end

      def reasons
        kind.fetch('errors', []).map{|e| e['reason']}
      end

    private

      def explanation
        'A request to YouTube API failed'
      end

      def more_details
      end

      def response_body
        json['response_body']
      end

      def request_curl
        json['request_curl']
      end

      def json
        @json ||= JSON(@msg) rescue {}
      end
    end
  end

  Error = Errors::RequestError
end