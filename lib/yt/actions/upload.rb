require 'net/http'
require 'yt/actions/base'

module Yt
  module Actions
    module Upload
      include Base

      private

      def do_upload(extra_upload_params = {})
        params = upload_params.merge(extra_upload_params)
        uri = params[:uri]
        http = params[:http] || new_upload_http(uri)

        req = Net::HTTP::Put.new(uri.request_uri)
        params.fetch(:headers, {}).each { |k, v| req[k] = v }
        req['Authorization'] = "Bearer #{params[:token]}"

        body = params[:body]
        if body.nil?
          # no body (e.g. status check)
        elsif body.respond_to?(:read)
          req.body_stream = body
          req['Transfer-Encoding'] = 'chunked'
        else
          req.body = body
        end

        response = http.request(req)
        block_given? ? yield(response) : response
      end

      def upload_params
        {}
      end

      def new_upload_http(uri)
        Net::HTTP.new(uri.host, uri.port).tap do |http|
          http.use_ssl = uri.scheme == 'https'
          http.open_timeout = 30
          http.read_timeout = 300
          http.start
        end
      end
    end
  end
end
