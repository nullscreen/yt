require 'yt/config'

require 'uri' # for URI.json
require 'net/http' # for Net::HTTP.start
require 'json' # for JSON.parse
require 'active_support/core_ext/hash/conversions' # for Hash.from_xml

module Yt
  class RequestError < StandardError
    def reasons
      error.fetch('errors', []).map{|e| e['reason']}
    end

    def error
      eval(message)['error'] rescue {}
    end
  end

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
        unless response.is_a? Net::HTTPSuccess
          # puts "You can try again running #{to_curl}"
          raise RequestError, response.body
        end
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
        request = if @body_type == :json
          klass.new @uri, initheader = {'Content-Type' =>'application/json'}
        else
          klass.new @uri
        end
        @headers.each{|k,v| request.add_field k, v}
        case @body_type
          when :json then request.body = @body.to_json
          when :form then request.set_form_data @body
        end if @body

        http.request request
        # NOTE! Here refresh the token if the access is expired
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