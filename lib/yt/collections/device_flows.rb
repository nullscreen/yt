require 'yt/collections/base'
require 'yt/models/device_flow'

module Yt
  module Collections
    class DeviceFlows < Base
      attr_accessor :auth_params

    private

      def new_item(data)
        Yt::DeviceFlow.new data: data
      end

      def list_params
        super.tap do |params|
          params[:host] = 'accounts.google.com'
          params[:path] = '/o/oauth2/device/code'
          params[:body_type] = :form
          params[:method] = :post
          params[:auth] = nil
          params[:body] = auth_params
        end
      end

      def next_page
        request = Yt::Request.new list_params
        Array.wrap request.run.body
      end
    end
  end
end