module Yt
  module Errors
    class Base < StandardError
      def initialize(msg = nil)
        @msg = msg
        super msg
      end

      def reasons
        kind.fetch('errors', []).map{|e| e['reason']}
      end

      def kind
        response_body.fetch 'error', {}
      end

    private

      def response_code
        Integer(response['code']) rescue nil
      end

      def response_body
        body = response['body']
        JSON(body) rescue {body: body}
      end

      def request_curl
        # TODO.. continue
        %Q{curl -X #{request['method'].to_s.upcase} "#{request['url']}"}
      end

      def request
        json['request'] || {}
      end

      def response
        json['response'] || {}
      end

      def json
        JSON(@msg) rescue {}
      end
    end
  end
end