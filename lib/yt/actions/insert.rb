require 'yt/utils/request'

module Yt
  module Actions
    module Insert

    private

      def do_insert(extra_insert_params = {})
        request = Request.new insert_params.merge(extra_insert_params)
        response = request.run
        raise unless response.is_a? Net::HTTPOK
        @items = []
        new_item response.body
      end

      def insert_params
        {}.tap do |params|
          params[:method] = :post
          params[:format] = :json
          params[:host] = 'www.googleapis.com'
          params[:body_type] = :json
          params[:scope] = 'https://www.googleapis.com/auth/youtube'
          params[:auth] = @auth
        end
      end
    end
  end
end