require 'yt/request'
require 'yt/actions/base'
require 'yt/config'

module Yt
  module Actions
    module Insert
      include Base

    private

      def do_insert(extra_insert_params = {}, options = {})
        if options[:required_channel]
          check_channel_presence = proc do
            begin
              {errors:[{reason: 'channelNotFound', message: 'Channel not found.'}], message: 'Channel not found.'} unless options[:required_channel].status.is_linked?
            rescue Errors::Unauthorized
              nil
            end
          end
          extra_insert_params = extra_insert_params.merge(unauthorized_api_method: check_channel_presence)
        end
        response = insert_request(extra_insert_params).run
        @items = []
        new_item extract_data_from(response)
      end

      def insert_request(params = {})
        Yt::Request.new(insert_params.deep_merge params).tap do |request|
          print "#{request.as_curl}\n" if Yt.configuration.developing?
        end
      end

      def insert_params
        path = "/youtube/v3/#{self.class.to_s.demodulize.camelize :lower}"

        {}.tap do |params|
          params[:path] = path
          params[:host] = 'www.googleapis.com'
          params[:method] = :post
          params[:auth] = @auth
          params[:expected_response] = Net::HTTPOK
          params[:api_key] = Yt.configuration.api_key if Yt.configuration.api_key
        end
      end

      def extract_data_from(response)
        response.body
      end
    end
  end
end