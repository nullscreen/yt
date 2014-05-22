require 'net/http' # for Net::HTTP.start
require 'uri' # for URI.json
require 'json' # for JSON.parse
require 'active_support/core_ext' # for Hash.from_xml, Hash.to_param

require 'yt/config'
require 'yt/errors/failed'
require 'yt/errors/unauthenticated'

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
          raise Errors::MissingAuth, to_error(response)
        else
          raise Errors::Failed, to_error(response)
        end
      end

    private

      def response
        @response ||= Net::HTTP.start(*net_http_options) do |http|
          http.request http_request
        end
      end

      def http_request
        net_http_class.new(uri.request_uri).tap do |request|
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
        else
          raise Errors::Unauthenticated, to_error
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

      def to_error(response = nil)
        request_msg = {}.tap do |msg|
          msg[:method] = @method
          msg[:headers] = @headers
          msg[:url] = @uri.to_s
          msg[:body] = @body
        end

        response_msg = {}.tap do |msg|
          msg[:code] = response.code
          msg[:headers] = {}.tap{|h| response.each_header{|k,v| h[k] = v }}
          msg[:body] = response.body
        end if response

        {request: request_msg, response: response_msg}.to_json
      end
    end
  end
end