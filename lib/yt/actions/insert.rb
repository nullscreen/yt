require 'yt/models/request'

module Yt
  module Actions
    module Insert

    private

      def do_insert(extra_insert_params = {})
        request = Yt::Request.new insert_params.merge(extra_insert_params)
        response = request.run
        @items = []
        new_item response.body
      end

      def insert_params
        {}.tap do |params|
          params[:method] = :post
          params[:auth] = @auth
          params[:expected_response] = Net::HTTPOK
        end
      end
    end
  end
end