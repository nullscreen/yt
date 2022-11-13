require 'yt/collections/authentications'
require 'yt/models/revocation'

module Yt
  module Collections
    class Revocations < Authentications
      attr_accessor :auth_params

    private

      # This overrides the parent mehthod defined in Authentications
      def attributes_for_new_item(data)
        {data: data}
      end

      def list_params
        super.tap do |params|
          params[:host] = 'oauth2.googleapis.com'
          params[:path] = '/revoke'
          params[:request_format] = :form
          params[:method] = :post
          params[:auth] = nil
          params[:body] = nil
          params[:camelize_body] = false
          params[:params] = auth_params
        end
      end
    end
  end
end
