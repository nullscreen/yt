require 'yt/actions/request'

module Yt
  module Actions
    module Delete

    private

      def do_delete(extra_delete_params = {})
        request = Request.new delete_params.merge(extra_delete_params)
        response = request.run
        raise unless response.is_a? Net::HTTPNoContent
        yield response.body
      end

      def delete_params
        Request.default_params.tap do |params|
          params[:method] = :delete
          params[:auth] = @auth
        end
      end
    end
  end
end