require 'yt/collections/base'
require 'yt/models/authentication'
require 'yt/errors/failed'

module Yt
  module Collections
    class Authentications < Base
      attr_accessor :auth_params

    private

      def new_item(data)
        Yt::Authentication.new data
      end

      def list_params
        super.tap do |params|
          params[:host] = 'accounts.google.com'
          params[:path] = '/o/oauth2/token'
          params[:body_type] = :form
          params[:method] = :post
          params[:auth] = nil
          params[:body] = auth_params
        end
      end

      def more_pages?
        auth_params.values.all?
      end

      def next_page
        request = Yt::Request.new list_params
        Array.wrap request.run.body
      rescue Yt::Errors::Failed => error
        expected?(error) ? [] : raise(error)
      end

      def expected?(error)
        error.kind == 'invalid_grant'
      end
    end
  end
end
