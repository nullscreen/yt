require 'yt/collections/authentications'
require 'yt/models/device_flow'

module Yt
  module Collections
    class DeviceFlows < Authentications
      attr_accessor :auth_params

    private

      def new_item(data)
        Yt::DeviceFlow.new data: data
      end

      def list_params
        super.tap do |params|
          params[:path] = '/o/oauth2/device/code'
        end
      end
    end
  end
end