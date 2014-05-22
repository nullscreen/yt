require 'yt/models/request'

module Yt
  module Actions
    module Update

    private

      def do_update(extra_update_params = {})
        request = Yt::Request.new update_params.deep_merge(extra_update_params)
        response = request.run
        yield response.body
      end

      def update_params
        Yt::Request.default_params.tap do |params|
          params[:method] = :put
          params[:auth] = @auth
          params[:expected_response] = Net::HTTPNoContent
        end
      end
    end
  end
end