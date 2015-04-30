require 'yt/collections/base'
require 'yt/models/user_info'

module Yt
  module Collections
    # @private
    class UserInfos < Base

    private

      # @return [Hash] the parameters to submit to YouTube to get the
      #   user info of an account
      # @see https://developers.google.com/+/api/latest/people/getOpenIdConnect
      def list_params
        super.tap do |params|
          params[:path] = '/oauth2/v2/userinfo'
          params[:expected_response] = Net::HTTPOK
        end
      end

      # next_page is overloaded here because, differently from the other
      # endpoints, asking for the user info does not return a paginated result,
      # so @page_token has to be explcitly set to nil, and the result wrapped
      # in an Array.
      def next_page
        request = Yt::Request.new(list_params).tap do |request|
          print "#{request.as_curl}\n" if Yt.configuration.developing?
        end
        response = request.run
        @page_token = nil

        Array.wrap response.body
      end
    end
  end
end