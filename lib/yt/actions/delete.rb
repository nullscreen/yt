require 'yt/models/request'

module Yt
  module Actions
    module Delete

    private

      def do_delete(extra_delete_params = {})
        request = Yt::Request.new delete_params.merge(extra_delete_params)
        response = request.run
        yield response.body
      end

      def delete_params
        Yt::Request.default_params.tap do |params|
          params[:method] = :delete
          params[:auth] = @auth
          params[:expected_response] = Net::HTTPNoContent
        end
      end
    end
  end
end