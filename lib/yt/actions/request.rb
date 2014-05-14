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
      add_authorization_to_request! if requires_authorization?
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
      elsif Yt.configuration.api_key
        params = URI.decode_www_form @uri.query || ''
        params << [:key, Yt.configuration.api_key]
        @uri.query = URI.encode_www_form params
      else
        raise RequestError, missing_credentials
      end
    end

    def requires_authorization?
      @uri.host == Request.default_params[:host]
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

    def missing_credentials
      <<-MSG
      In order to perform this request, you need to register your app with the
      Google Developers Console (https://console.developers.google.com).

      Make sure your app has access to the Google+ and YouTube APIs.
      Generate a client ID, client secret and server API key, then pass their
      values to Yt. One way of doing this is through an initializer:

      Yt.configure do |config|
        config.client_id = '1234567890.apps.googleusercontent.com'
        config.client_secret = '1234567890'
        config.api_key = '123456789012345678901234567890'
      end

      An alternative (but equivalent) way is throught environment variables:

      export YT_CLIENT_ID="1234567890.apps.googleusercontent.com"
      export YT_CLIENT_SECRET="1234567890"
      export YT_API_KEY="123456789012345678901234567890"

      MSG
    end

    # def to_curl
    #   %Q{curl -X #{@method.upcase} "#{@uri}"}
    # end
  end
end