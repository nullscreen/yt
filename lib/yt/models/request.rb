require 'net/http' # for Net::HTTP.start
require 'uri' # for URI.json
require 'json' # for JSON.parse
require 'active_support/core_ext' # for Hash.from_xml, Hash.to_param

require 'yt/config'
require 'yt/errors/missing_auth'
require 'yt/errors/request_error'

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
        case response
        when @expected_response
          response.tap{|response| response.body = parse_format response.body}
        when Net::HTTPUnauthorized
          raise Errors::MissingAuth, request_error_message
        else
          raise Yt::Error, request_error_message
        end
      end

    private

      def response
        @response ||= Net::HTTP.start(*net_http_options) do |http|
          http.request http_request
        end
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

      def request_error_message
        {}.tap do |message|
          message[:request_curl] = as_curl
          message[:response_body] = JSON(response.body) rescue response.body
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