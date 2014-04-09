require 'uri'
require 'json'

module Googol
  # A custom class to rescue errors from interacting with Google V3 API
  class RequestError < StandardError
  end

  # Provides methods to send HTTP requests to Google V3 API
  module Requestable
    ##
    # Executes an HTTP request against the Google V3 API and returns the
    # parsed result or raise an error in case of failure
    #
    # @note Not the best code quality, feel free to refactor!
    #
    def request!(params = {})
      url = URI.parse params[:host]
      http = Net::HTTP.new url.host, url.port
      http.use_ssl = true
      request = case params[:method]
        when :get then Net::HTTP::Get.new params[:path]
        when :post then
          if params[:json]
            Net::HTTP::Post.new params[:path], initheader = {'Content-Type' =>'application/json'}
          else
            Net::HTTP::Post.new params[:path]
          end
      end
      if params[:json]
        request.body = params[:body].to_json
      else
        request.set_form_data params[:body]
      end if params[:body]

      request['Authorization'] = 'Bearer ' + params[:auth] if params[:auth]
      response = http.request(request)

      body = JSON.parse response.body if response.body

      if params[:valid_if] ? params[:valid_if].call(response, body) : true
        body = params[:extract].call body if params[:extract]
        body ? deep_symbolize_keys(body) : true
      else
        raise RequestError, body
      end
    end

  private

    def deep_symbolize_keys(hash)
      {}.tap do |result|
        hash.each do |k, v|
          key = k.to_sym rescue k
          result[key] = v.is_a?(Hash) ? deep_symbolize_keys(v) : v
        end
      end
    end
  end
end