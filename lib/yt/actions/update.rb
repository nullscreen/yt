require 'yt/actions/request'

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
        Request.default_params.tap do |params|
          params[:method] = :put
          params[:auth] = @auth
        end
      end
    end
  end
end