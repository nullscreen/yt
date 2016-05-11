require 'yt/config'

module Yt
  module Errors
    class RequestError < StandardError
      def initialize(msg = {})
        @msg = msg
        super msg
      end

      def message
        <<-MSG.gsub(/^ {8}/, '')
        #{explanation}:
        #{Yt.configuration.debugging? ? details : no_details }
        MSG
      end

      def kind
        response_body.fetch 'error', {}
      end

      def description
        response_body.fetch 'error_description', {}
      end

      def reasons
        case kind
          when Hash then kind.fetch('errors', []).map{|e| e['reason']}
          else kind
        end
      end

      def explanation
        'A request to YouTube API failed'
      end

      def response_body
        json['response_body'].is_a?(Hash) ? json['response_body'] : {}
      end

    private

      def details
        <<-MSG.gsub(/^ {8}/, '')
        #{response_body}

        You can retry the same request manually by running:
        #{request_curl}
        #{more_details}
        MSG
      end

      def no_details
        <<-MSG.gsub(/^ {8}/, '')
        To display more verbose errors, change the configuration of Yt with:

        Yt.configure do |config|
          config.log_level = :debug
        end
        MSG
      end

      def more_details
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
