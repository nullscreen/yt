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
          params[:host] = 'accounts.google.com'
          params[:path] = '/o/oauth2/revoke'
          params[:request_format] = nil
          params[:method] = :get
          params[:auth] = nil
          params[:body] = nil
          params[:camelize_body] = false
          params[:params] = auth_params
        end
      end
    end
  end
end
