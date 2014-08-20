require 'yt/models/request'

module Yt
  module Actions
    # Abstract module that contains method for getting
    module Get

    private

      def do_get(params = {})
        request = Yt::Request.new get_params.deep_merge(params)
        response = request.run
        yield response.body if block_given?
      end

      def get_params
        path = "/youtube/v3/#{self.class.to_s.demodulize.pluralize.camelize :lower}"

        {}.tap do |params|
          params[:method] = :get
          params[:path] = path
          params[:auth] = @auth
          params[:expected_response] = Net::HTTPOK
        end
      end
    end
  end
end