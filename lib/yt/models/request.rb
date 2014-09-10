require 'net/http' # for Net::HTTP.start
require 'uri' # for URI.json
require 'json' # for JSON.parse
require 'active_support' # does not load anything by default  but is required
require 'active_support/core_ext' # for Hash.from_xml, Hash.to_param

require 'yt/errors/unauthorized'
require 'yt/errors/request_error'
require 'yt/errors/server_error'
require 'yt/errors/forbidden'

module Yt
  module Models
    class Request
      def initialize(options = {})
        @auth = options[:auth]
        @file = options[:file]
        @body_type = options.fetch :body_type, :json
        @expected_response = options.fetch :expected_response, Net::HTTPSuccess
        @format = options.fetch :format, :json
        @headers = options.fetch :headers, gzip_headers
        @host = options.fetch :host, google_api_host
        @method = options.fetch :method, :get
        @path = options[:path]
        @body = options[:body]
        camelize_keys! @body if options.fetch(:camelize_body, true)
        params = options.fetch :params, {}
        params.merge! key: options[:api_key] if options[:api_key]
        camelize_keys! params if options.fetch(:camelize_params, true)
        @query = params.to_param
      end


      def run
        if response.is_a? @expected_response
          response.tap{|response| response.body = parse_format response.body}
        else
          run_again? ? run : raise(response_error, request_error_message)
        end
      end

      def as_curl
        'curl'.tap do |curl|
          curl <<  " -X #{http_request.method}"
          http_request.each_header do |name, value|
            next if gzip_headers.has_key? name
            curl << %Q{ -H "#{name}: #{value}"}
          end
          curl << %Q{ -d '#{http_request.body}'} if http_request.body
          curl << %Q{ "#{@uri.to_s}"}
        end
      end

    private

      def response
        @response ||= send_http_request
      rescue OpenSSL::SSL::SSLError, Errno::ETIMEDOUT, Errno::ENETUNREACH, Errno::ECONNRESET => e
        @response ||= e
      end

      def send_http_request
        ActiveSupport::Notifications.instrument 'request.yt' do |payload|
          payload[:method] = @method
          payload[:request_uri] = uri
          payload[:response] = Net::HTTP.start(*net_http_options) do |http|
            http.request http_request
          end
        end
      end

      def http_request
        @http_request ||= net_http_class.new(uri.request_uri).tap do |request|
          set_headers! request
          set_body! request
        end
      end

      def set_headers!(request)
        case @body_type
        when :json
          request.initialize_http_header 'Content-Type' => 'application/json'
          request.initialize_http_header 'Content-length' => '0' unless @body
        when :file
          request.initialize_http_header 'Content-Length' => @body.size.to_s
          request.initialize_http_header 'Transfer-Encoding' => 'chunked'
        end
        @headers.each{|name, value| request.add_field name, value}
      end

      # To receive a gzip-encoded response you must do two things:
      # - Set the Accept-Encoding HTTP request header to gzip.
      # - Modify your user agent to contain the string gzip.
      # Net::HTTP already sets the Accept-Encoding header, so all it’s left
      # to do is to specify an appropriate User Agent.
      # @see https://developers.google.com/youtube/v3/getting-started#gzip
      # @see http://www.ietf.org/rfc/rfc2616.txt
      def gzip_headers
        @gzip_headers ||= {}.tap do |headers|
          headers['user-agent'] = 'Yt (gzip)'
        end
      end

      def set_body!(request)
        case @body_type
          when :json then request.body = @body.to_json
          when :form then request.set_form_data @body
          when :file then request.body_stream = @body
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

      def camelize_keys!(object)
        return object unless object.is_a?(Hash)
        object.dup.each_key do |key|
          object[key.to_s.camelize(:lower).to_sym] = object.delete key
        end
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
          else false
        end
      end

      # If a request authorized with an access token returns 401, then the
      # access token might have expired. If a refresh token is also present,
      # try to run the request one more time with a refreshed access token.
      # If it's not present, then don't raise the returned MissingAuth, just
      # let the original error bubble up.
      def refresh_token_and_retry?
        if response.is_a? Net::HTTPUnauthorized
          @auth.refresh.tap { @response = @http_request = @uri = nil }
        end if @auth.respond_to? :refresh
      rescue Errors::MissingAuth
        false
      end

      def request_error_message
        {}.tap do |message|
          message[:request_curl] = as_curl
          message[:response_body] = JSON(response.body) rescue response.inspect
        end.to_json
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
    end
  end
end