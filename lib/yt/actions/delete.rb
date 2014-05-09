require 'yt/utils/request'

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
        {}.tap do |params|
          params[:method] = :delete
          params[:format] = :json
          params[:host] = 'www.googleapis.com'
          params[:scope] = 'https://www.googleapis.com/auth/youtube'
          params[:auth] = @auth
        end
      end
    end
  end
end