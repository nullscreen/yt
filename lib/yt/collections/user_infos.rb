require 'yt/collections/base'
require 'yt/models/user_info'

module Yt
  module Collections
    class UserInfos < Base

    private

      def new_item(data)
        Yt::UserInfo.new data: data
      end

      def list_params
        super.tap do |params|
          params[:path] = '/oauth2/v2/userinfo'
          params[:expected_response] = Net::HTTPOK
        end
      end

      def next_page
        request = Yt::Request.new list_params
        response = request.run
        @page_token = nil
        
        Array.wrap response.body
      end
    end
  end
end