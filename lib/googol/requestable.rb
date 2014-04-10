require 'uri'
require 'json'
require 'net/http'

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
        when :post then
          if params[:json]
            Net::HTTP::Post.new params[:path], initheader = {'Content-Type' =>'application/json'}
          else
            Net::HTTP::Post.new params[:path]
          end
        else Net::HTTP::Get.new params[:path]
      end
      if params[:json]
        request.body = params[:body].to_json
      else
        request.set_form_data params[:body]
      end if params[:body]

      request['Authorization'] = 'Bearer ' + params[:auth] if params[:auth]

      response = http.request(request)

      body = JSON.parse response.body if response.body

      if response.code == params.fetch(:code, 200).to_s
        body ? deep_symbolize_keys(body) : true
      else
        raise RequestError, body
      end
    end

  private

    def deep_symbolize_keys(hash)
      def symbolize(value)
        case value
          when Hash then deep_symbolize_keys value
          when Array then value.map{|item| symbolize item}
          else value
        end
      end

      {}.tap do |result|
        hash.each do |k, v|
          key = k.to_sym rescue k
          result[key] = symbolize v
        end
      end
    end
  end
end