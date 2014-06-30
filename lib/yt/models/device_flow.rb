require 'yt/models/base'

module Yt
  module Models
    class DeviceFlow < Base
      def initialize(options = {})
        @data = options[:data]
      end

      def device_code
        @device_code ||= @data['device_code']
      end

      def user_code
        @user_code ||= @data['user_code']
      end

      def verification_url
        @verification_url ||= @data['verification_url']
      end
    end
  end
end