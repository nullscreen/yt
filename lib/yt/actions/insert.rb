require 'yt/models/request'

module Yt
  module Actions
    module Insert

    private

      def do_insert(extra_insert_params = {})
        camelize_keys! extra_insert_params[:body] if extra_insert_params[:body] && insert_params.fetch(:camelize_body, true)
        camelize_keys! extra_insert_params[:params] if extra_insert_params[:params] && insert_params.fetch(:camelize_params, true)

        request = Yt::Request.new insert_params.deep_merge(extra_insert_params)
        response = request.run
        @items = []
        new_item extract_data_from(response)
      end

      def insert_params
        path = "/youtube/v3/#{self.class.to_s.demodulize.camelize :lower}"

        {}.tap do |params|
          params[:path] = path
          params[:method] = :post
          params[:auth] = @auth
          params[:expected_response] = Net::HTTPOK
          params[:camelize_params] = true
          params[:camelize_body] = true
        end
      end

      def extract_data_from(response)
        response.body
      end

      def camelize_keys!(hash = {})
        hash.dup.each_key do |key|
          hash[key.to_s.camelize(:lower).to_sym] = hash.delete key
        end
      end

    end
  end
end