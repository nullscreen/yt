require 'net/http' # for Net::HTTP.start
require 'uri' # for URI.json
require 'json' # for JSON.parse
require 'active_support/core_ext' # for Hash.from_xml, Hash.to_param

require 'yt/actions/request_error'
require 'yt/config'

module Yt
  class Request
    def initialize(options = {})
      options[:query] ||= options[:params].to_param
      @uri = URI::HTTPS.build options.slice(:host, :path, :query)
      @method = options[:method]
      @format = options[:format]
      @scope = options[:scope]
      @body = options[:body]
      @body_type = options[:body_type]
      @auth = options[:auth]
      @headers = {}
    end

    def run
      add_authorization_to_request!
      fetch_response.tap do |response|
        response.body = parse_format response.body if response.body
        # puts "You can try again running #{to_curl}"
        raise RequestError, response.body unless response.is_a? Net::HTTPSuccess
      end
    end

    def self.default_params
      {}.tap do |params|
        params[:format] = :json
        params[:host] = 'www.googleapis.com'
        params[:scope] = 'https://www.googleapis.com/auth/youtube'
        params[:body_type] = :json
      end
    end

  private

    def add_authorization_to_request!
      if @auth.respond_to? :access_token_for
        @headers['Authorization'] = "Bearer #{@auth.access_token_for @scope}"
      else # TODO: check if api_key was set in the first place!!
        params = URI.decode_www_form @uri.query || ''
        params << [:key, Yt.configuration.api_key]
        @uri.query = URI.encode_www_form params
      end
    end

    def fetch_response
      Net::HTTP.start(@uri.host, @uri.port, use_ssl: true) do |http|
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

        http.request request
      end
    end

    def parse_format(body)
      case @format
        when :xml then Hash.from_xml body
        when :json then JSON body
      end
    end

    # def to_curl
    #   %Q{curl -X #{@method.upcase} "#{@uri}"}
    # end
  end
end