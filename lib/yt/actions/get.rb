require 'yt/request'

module Yt
  module Actions
    module Get
      include Base

      def get
        response = get_request(get_params).run
        @data.merge! response.body
        self
      end

    private

      def get_request(params = {})
        @list_request = Yt::Request.new(params).tap do |request|
          print "#{request.as_curl}\n" if Yt.configuration.developing?
        end
      end

      def get_params
        {}.tap do |params|
          params[:method] = :get
          params[:host] = 'www.googleapis.com'
          params[:auth] = @auth
          params[:exptected_response] = Net::HTTPOK
          params[:api_key] = Yt.configuration.api_key if Yt.configuration.api_key
        end
      end
    end
  end
end