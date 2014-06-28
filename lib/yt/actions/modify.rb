require 'yt/models/request'

module Yt
  module Actions
    # Abstract module that contains methods common to Delete and Update
    module Modify

    private

      def do_modify(params = {})
        request = Yt::Request.new params
        response = request.run
        yield response.body
      end

      def modify_params
        path = "/youtube/v3/#{self.class.to_s.demodulize.pluralize.camelize :lower}"

        {}.tap do |params|
          params[:path] = path
          params[:auth] = @auth
          params[:expected_response] = Net::HTTPNoContent
        end
      end
    end
  end
end