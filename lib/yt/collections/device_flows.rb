require 'yt/collections/authentications'
require 'yt/models/device_flow'

module Yt
  module Collections
    class DeviceFlows < Authentications
      attr_accessor :auth_params

    private

      # This overrides the parent mehthod defined in Authentications
      def attributes_for_new_item(data)
        {data: data}
      end

      def list_params
        super.tap do |params|
          params[:path] = '/o/oauth2/device/code'
        end
      end
    end
  end
end