require 'yt/actions/request'

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
        Request.default_params.tap do |params|
          params[:method] = :post
          params[:auth] = @auth
        end
      end
    end
  end
end