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
        options[:query] ||= options[:params].to_param
        @uri = URI::HTTPS.build options.slice(:host, :path, :query)
        @method = options.fetch :method, :get
        @format = options[:format]
        @body = options[:body]
        @body_type = options[:body_type]
        @auth = options[:auth]
        @expected_response = options.fetch :expected_response, Net::HTTPSuccess
        @headers = {}
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

      def self.default_params
        {}.tap do |params|
          params[:format] = :json
          params[:host] = 'www.googleapis.com'
          params[:body_type] = :json
        end
      end

    private

      def add_authorization_to_request!
        if @auth.respond_to? :access_token
          @headers['Authorization'] = "Bearer #{@auth.access_token}"
        elsif Yt.configuration.api_key
          params = URI.decode_www_form @uri.query || ''
          params << [:key, Yt.configuration.api_key]
          @uri.query = URI.encode_www_form params
        else
          raise Errors::Unauthenticated, to_error
        end
      end

      def requires_authorization?
        @uri.host == Request.default_params[:host]
      end

      def fetch_response
        klass = "Net::HTTP::#{@method.capitalize}".constantize
        request = klass.new @uri.request_uri
        case @body_type
        when :json
          request.initialize_http_header 'Content-Type' => 'application/json'
          request.initialize_http_header 'Content-length' => '0' unless @body
          request.body = @body.to_json if @body
        when :form
          request.set_form_data @body if @body
        end
        @headers.each{|k,v| request.add_field k, v}

        Net::HTTP.start(@uri.host, @uri.port, use_ssl: true) do |http|
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