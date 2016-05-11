require 'yt/collections/base'
require 'yt/models/authentication'

module Yt
  module Collections
    # @private
    class Authentications < Base
      attr_accessor :auth_params

    private

      def attributes_for_new_item(data)
        data['refresh_token'] ||= auth_params[:refresh_token]
        data
      end

      def list_params
        super.tap do |params|
          params[:host] = 'accounts.google.com'
          params[:path] = '/o/oauth2/token'
          params[:request_format] = :form
          params[:method] = :post
          params[:auth] = nil
          params[:body] = auth_params
          params[:camelize_body] = false
        end
      end

      def more_pages?
        auth_params.values.all?
      end

      def next_page
        request = Yt::Request.new(list_params).tap do |request|
          print "#{request.as_curl}\n" if Yt.configuration.developing?
        end
        Array.wrap request.run.body
      rescue Yt::Error => error
        expected?(error) ? [] : raise(error)
      end

      def expected?(error)
        error.kind == 'invalid_grant' &&
          invalid_code_errors.exclude?(error.description)
      end

    private

      def invalid_code_errors
        ["Code was already redeemed.", "Invalid code."]
      end
    end
  end
end
