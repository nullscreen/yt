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
        add_authorization_to_request! if requires_authorization?
        fetch_response.tap do |response|
          if response.is_a? @expected_response
            response.body = parse_format response.body
          elsif response.is_a? Net::HTTPUnauthorized
            raise Errors::MissingAuth, to_error(response)
          else
            raise Errors::Failed, to_error(response)
          end
        end
      end

    private

      def add_authorization_to_request!
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

      def requires_authorization?
        @host == google_api_host
      end

      def google_api_host
        'www.googleapis.com'
      end

      def uri
        @uri ||= URI::HTTPS.build host: @host, path: @path, query: @query
      end

      def fetch_response
        klass = "Net::HTTP::#{@method.capitalize}".constantize
        request = klass.new uri.request_uri
        case @body_type
        when :json
          request.initialize_http_header 'Content-Type' => 'application/json'
          request.initialize_http_header 'Content-length' => '0' unless @body
          request.body = @body.to_json if @body
        when :form
          request.set_form_data @body if @body
        end
        @headers.each{|k,v| request.add_field k, v}

        Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          http.request request
        end
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
          msg[:url] = uri.to_s
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