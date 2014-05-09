require 'yt/utils/request'

module Yt
  module Actions
    module Update
      def do_update(extra_update_params = {}, options = {})
        request = Request.new update_params.deep_merge(extra_update_params)
        response = request.run
        expected_response = options.fetch :expect, Net::HTTPNoContent
        raise unless response.is_a? expected_response
        yield response.body
      end

      def update_params
        {}.tap do |params|
          params[:method] = :put
          params[:format] = :json
          params[:host] = 'www.googleapis.com'
          params[:scope] = 'https://www.googleapis.com/auth/youtube'
          params[:auth] = @auth
        end
      end
    end
  end
end