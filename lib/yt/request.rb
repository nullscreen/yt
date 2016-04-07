require 'net/http' # for Net::HTTP.start
require 'uri' # for URI.json
require 'json' # for JSON.parse
require 'active_support' # does not load anything by default  but is required
require 'active_support/core_ext' # for Hash.from_xml, Hash.to_param

require 'yt/errors/forbidden'
require 'yt/errors/missing_auth'
require 'yt/errors/request_error'
require 'yt/errors/server_error'
require 'yt/errors/unauthorized'

module Yt
  # @private
  # A wrapper around Net::HTTP to send HTTP requests to any web API and
  # return their result or raise an error if the result is unexpected.
  # The basic way to use Request is by calling +run+ on an instance.
  # @example List the most popular videos on YouTube.
  #   host = ''www.googleapis.com'
  #   path = '/youtube/v3/videos'
  #   params = {chart: 'mostPopular', key: ENV['API_KEY'], part: 'snippet'}
  #   response = Yt::Request.new(path: path, params: params).run
  #   response.body['items'].map{|video| video['snippet']['title']}
  #
  class Request
    # Initializes a Request object.
    # @param [Hash] options the options for the request.
    # @option options [String, Symbol] :method (:get) The HTTP method to use.
    # @option options [Class] :expected_response (Net::HTTPSuccess) The class
    #   of response that the request should obtain when run.
    # @option options [String, Symbol] :response_format (:json) The expected
    #   format of the response body. If passed, the response body will be
    #   parsed according to the format before being returned.
    # @option options [String] :host The host component of the request URI.
    # @option options [String] :path The path component of the request URI.
    # @option options [Hash] :params ({}) The params to use as the query
    #   component of the request URI, for instance the Hash +{a: 1, b: 2}+
    #   corresponds to the query parameters "a=1&b=2".
    # @option options [Hash] :camelize_params (true) whether to transform
    #   each key of params into a camel-case symbol before sending the request.
    # @option options [Hash] :request_format (:json) The format of the
    #   requesty body. If a request body is passed, it will be parsed
    #   according to this format before sending it in the request.
    # @option options [#size] :body The body component of the request.
    # @option options [Hash] :headers ({}) The headers component of the
    #   request.
    # @option options [#access_token, #refreshed_access_token?] :auth The
    #   authentication object. If set, must respond to +access_token+ and
    #   return the OAuth token to make an authenticated request, and must
    #   respond to +refreshed_access_token?+ and return whether the access
    #   token can be refreshed if expired.
    def initialize(options = {})
      @method = options.fetch :method, :get
      @expected_response = options.fetch :expected_response, Net::HTTPSuccess
      @response_format = options.fetch :response_format, :json
      @host = options[:host]
      @path = options[:path]
      @params = options.fetch :params, {}
      # Note: This is to be invoked by auth-only YouTube APIs.
      @params[:key] = options[:api_key] if options[:api_key]
      # Note: This is to be invoked by all YouTube API except Annotations,
      # Analyitics and Uploads
      camelize_keys! @params if options.fetch(:camelize_params, true)
      @request_format = options.fetch :request_format, :json
      @body = options[:body]
      @headers = options.fetch :headers, {}
      @auth = options[:auth]
    end

    # Sends the request and returns the response.
    # If the request fails once for a temporary server error or an expired
    # token, tries the request again before eventually raising an error.
    # @return [Net::HTTPResponse] if the request succeeds and matches the
    #   expectations, the response with the body appropriately parsed.
    # @raise [Yt::RequestError] if the request fails or the response does
    #   not match the expectations.
    def run
      if matches_expectations?
        response.tap{parse_response!}
      elsif run_again?
        run
      else
        raise response_error, error_message.to_json
      end
    end

    # Returns the +cURL+ version of the request, useful to re-run the request
    # in a shell terminal.
    # @return [String] the +cURL+ version of the request.
    def as_curl
      'curl'.tap do |curl|
        curl <<  " -X #{http_request.method}"
        http_request.each_header{|k, v| curl << %Q{ -H "#{k}: #{v}"}}
        curl << %Q{ -d '#{http_request.body}'} if http_request.body
        curl << %Q{ "#{uri.to_s}"}
      end
    end

  private

    # @return [URI::HTTPS] the (memoized) URI of the request.
    def uri
      attributes = {host: @host, path: @path, query: @params.to_param}
      @uri ||= URI::HTTPS.build attributes
    end

    # @return [Net::HTTPRequest] the full HTTP request object,
    #   inclusive of headers of request body.
    def http_request
      net_http_class = "Net::HTTP::#{@method.capitalize}".constantize
      @http_request ||= net_http_class.new(uri.request_uri).tap do |request|
        set_request_body! request
        set_request_headers! request
      end
    end

    # Adds the request body to the request in the appropriate format.
    # if the request body is a JSON Object, transform its keys into camel-case,
    # since this is the common format for JSON APIs.
    def set_request_body!(request)
      case @request_format
        when :json then request.body = (camelize_keys! @body).to_json
        when :form then request.set_form_data @body
        when :file then request.body_stream = @body
      end if @body
    end

    # Destructively converts all the keys of hash to camel-case symbols.
    # Note: This is to be invoked by all YouTube API except Accounts
    def camelize_keys!(hash)
      hash.keys.each do |key|
        hash[key.to_s.camelize(:lower).to_sym] = hash.delete key
      end if hash.is_a? Hash
      hash
    end

    # Adds the request headers to the request in the appropriate format.
    # The User-Agent header is also set to recognize the request, and to
    # tell the server that gzip compression can be used, since Net::HTTP
    # supports it and automatically sets the Accept-Encoding header.
    def set_request_headers!(request)
      case @request_format
      when :json
        request.initialize_http_header 'Content-Type' => 'application/json'
        request.initialize_http_header 'Content-length' => '0' unless @body
      when :file
        request.initialize_http_header 'Content-Length' => @body.size.to_s
        request.initialize_http_header 'Transfer-Encoding' => 'chunked'
      end
      @headers['User-Agent'] = 'Yt::Request (gzip)'
      @headers['Authorization'] = "Bearer #{@auth.access_token}" if @auth
      @headers.each{|name, value| request.add_field name, value}
    end

    # @return [Boolean] whether the class of response returned by running
    #   the request matches the expected class of response.
    def matches_expectations?
      response.is_a? @expected_response
    end

    # Run the request and memoize the response or the server error received.
    def response
      @response ||= send_http_request
    rescue *server_errors => e
      @response ||= e
    end

    # Send the request to the server, allowing ActiveSupport::Notifications
    # client to subscribe to the request.
    def send_http_request
      net_http_options = [uri.host, uri.port, use_ssl: true]
      ActiveSupport::Notifications.instrument 'request.yt' do |payload|
        payload[:method] = @method
        payload[:request_uri] = uri
        payload[:response] = Net::HTTP.start(*net_http_options) do |http|
          http.request http_request
        end
      end
    end

    # Replaces the body of the response with the parsed version of the body,
    # according to the format specified in the Request.
    def parse_response!
      response.body = case @response_format
        when :xml then Hash.from_xml response.body
        when :json then JSON response.body
      end if response.body
    end

    # Returns whether it is worth to run a failed request again.
    # There are three cases in which retrying a request might be worth:
    # - when the server specifies that the request token has expired and
    #   the user has to refresh the token in order to try again
    # - when the server is unreachable, and waiting for a couple of seconds
    #   might solve the connection issues.
    # - when the user has reached the quota for requests/second, and waiting
    #   for a couple of seconds might solve the connection issues.
    def run_again?
      refresh_token_and_retry? ||
      server_error? && sleep_and_retry?(3) ||
      exceeded_quota? && sleep_and_retry?(3)
    end

    # Returns the list of server errors worth retrying the request once.
    def server_errors
      [
        OpenSSL::SSL::SSLError,
        Errno::ETIMEDOUT,
        Errno::EHOSTUNREACH,
        Errno::ENETUNREACH,
        Errno::ECONNRESET,
        Net::OpenTimeout,
        SocketError,
        Net::HTTPServerError
      ] + extra_server_errors
    end

    # Returns the list of server errors that are only raised (and therefore
    # can only be rescued) by specific versions of Ruby.
    # @see: https://github.com/Fullscreen/yt/pull/110
    def extra_server_errors
      if defined? OpenSSL::SSL::SSLErrorWaitReadable
        [OpenSSL::SSL::SSLErrorWaitReadable]
      else
        []
      end
    end

    # Sleeps for a while and returns true for the first +max_retries+ times,
    # then returns false. Useful to try the same request again multiple
    # times with a delay if a connection error occurs.
    def sleep_and_retry?(max_retries = 1)
      @retries_so_far ||= -1
      @retries_so_far += 1
      if (@retries_so_far < max_retries)
        @response = @http_request = @uri = nil
        sleep 3 + (10 * @retries_so_far)
      end
    end

    # In case an authorized request responds with "Unauthorized", checks
    # if the original access token can be refreshed. If that's the case,
    # clears the memoized variables and returns true, so the request can
    # be run again, otherwise raises an error.
    def refresh_token_and_retry?
      if unauthorized? && @auth && @auth.refreshed_access_token?
        @response = @http_request = @uri = nil
        true
      end
    rescue Errors::MissingAuth
      false
    end

    # @return [Yt::RequestError] the error associated to the class of the
    #   response.
    def response_error
      case response
        when *server_errors then Errors::ServerError
        when Net::HTTPUnauthorized then Errors::Unauthorized
        when Net::HTTPForbidden then Errors::Forbidden
        else Errors::RequestError
      end
    end

    # @return [Boolean] whether the response matches any server error.
    def server_error?
      response_error == Errors::ServerError
    end

    # @return [Boolean] whether the request exceeds the YouTube quota
    def exceeded_quota?
      response_error == Errors::Forbidden && response.body =~ /Exceeded/i
    end

    # @return [Boolean] whether the request lacks proper authorization.
    def unauthorized?
      response_error == Errors::Unauthorized
    end

    # Return the elements of the request/response that are worth displaying
    # as an error message if the request fails.
    # If the response format is JSON, showing the parsed body is sufficient,
    # otherwise the whole (inspected) response is worth looking at.
    def error_message
      response_body = JSON(response.body) rescue response.inspect
      {request_curl: as_curl, response_body: response_body}
    end
  end
end
