require 'net/http' # for Net::HTTP.start
require 'uri' # for URI.json
require 'json' # for JSON.parse
require 'active_support/core_ext' # for Hash.from_xml, Hash.to_param

require 'yt/config'
require 'yt/errors/unauthorized'
require 'yt/errors/request_error'
require 'yt/errors/server_error'
require 'yt/errors/forbidden'

module Yt
  module Models
    class Request
      def initialize(options = {})
        @auth = options[:auth]
        @body = options[:body]
        @body_type = options.fetch :body_type, :json
        @expected_response = options.fetch :expected_response, Net::HTTPSuccess
        @format = options.fetch :format, :json
        @headers = options.fetch :headers, {}
        @host = options.fetch :host, google_api_host
        @method = options.fetch :method, :get
        @path = options[:path]
        @query = options.fetch(:params, {}).to_param
      end

      def run
        if response.is_a? @expected_response
          response.tap{|response| response.body = parse_format response.body}
        else
          run_again? ? run : raise(response_error, request_error_message)
        end
      end

    private

      def response
        @response ||= Net::HTTP.start(*net_http_options) do |http|
          http.request http_request
        end
      rescue OpenSSL::SSL::SSLError, Errno::ETIMEDOUT, Errno::ENETUNREACH => e
        @response ||= e
      end

      def http_request
        @http_request ||= net_http_class.new(uri.request_uri).tap do |request|
          set_headers! request
          set_body! request
        end
      end

      def set_headers!(request)
        if @body_type == :json
          request.initialize_http_header 'Content-Type' => 'application/json'
          request.initialize_http_header 'Content-length' => '0' unless @body
        end
        @headers.each{|name, value| request.add_field name, value}
      end

      def set_body!(request)
        case @body_type
          when :json then request.body = @body.to_json
          when :form then request.set_form_data @body
        end if @body
      end

      def net_http_options
        [uri.host, uri.port, use_ssl: true]
      end

      def net_http_class
        "Net::HTTP::#{@method.capitalize}".constantize
      end

      def uri
        @uri ||= build_uri
      end

      def build_uri
        add_authorization! if @host == google_api_host
        URI::HTTPS.build host: @host, path: @path, query: @query
      end

      def add_authorization!
        if @auth.respond_to? :access_token
          @headers['Authorization'] = "Bearer #{@auth.access_token}"
        elsif Yt.configuration.api_key
          params = URI.decode_www_form @query || ''
          params << [:key, Yt.configuration.api_key]
          @query = URI.encode_www_form params
        end
      end

      def google_api_host
        'www.googleapis.com'
      end

      def parse_format(body)
        case @format
          when :xml then Hash.from_xml body
          when :json then JSON body
        end if body
      end

      # There are two cases to run a request again: YouTube responds with a
      # random error that can be fixed by waiting for some seconds and running
      # the exact same query, or the access token needs to be refreshed.
      def run_again?
        refresh_token_and_retry? || server_error? && sleep_and_retry?
      end

      # Once in a while, YouTube responds with 500, or 503, or 400 Error and
      # the text "Invalid query. Query did not conform to the expectations.".
      # In all these cases, running the same query after some seconds fixes
      # the issue. This it not documented by YouTube and hardly testable, but
      # trying again is a workaround that works and hardly causes any damage.
      def sleep_and_retry?(max_retries = 1)
        @retries_so_far ||= -1
        @retries_so_far += 1
        if (@retries_so_far < max_retries)
          @response = @http_request = @uri = nil
          sleep 3
        end
      end

      def server_error?
        case response
          when OpenSSL::SSL::SSLError then true
          when Errno::ETIMEDOUT then true
          when Errno::ENETUNREACH then true
          when Net::HTTPServerError then true
          when Net::HTTPBadRequest then response.body =~ /did not conform/
          else false
        end
      end

      # If a request authorized with an access token returns 401, then the
      # access token might have expired. If a refresh token is also present,
      # try to run the request one more time with a refreshed access token.
      def refresh_token_and_retry?
        if response.is_a? Net::HTTPUnauthorized
          @response = @http_request = @uri = nil
          @auth.refresh
        end if @auth.respond_to? :refresh
      end

      def response_error
        if server_error?
          Errors::ServerError
        else case response
          when Net::HTTPUnauthorized then Errors::Unauthorized
          when Net::HTTPForbidden then Errors::Forbidden
          else Errors::RequestError
          end
        end
      end

      def request_error_message
        {}.tap do |message|
          message[:request_curl] = as_curl
          message[:response_body] = JSON(response.body) rescue response.inspect
        end.to_json
      end

      def as_curl
        'curl'.tap do |curl|
          curl <<  " -X #{http_request.method}"
          http_request.each_header do |name, value|
            curl << %Q{ -H "#{name}: #{value}"}
          end
          curl << %Q{ -d '#{http_request.body}'} if http_request.body
          curl << %Q{ "#{@uri.to_s}"}
        end
      end
    end
  end
end