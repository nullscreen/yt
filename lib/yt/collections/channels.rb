require 'yt/collections/base'
require 'yt/models/channel'

module Yt
  module Collections
    class Channels < Base

    private

      def new_item(data)
        Yt::Channel.new id: data['id'], snippet: data['snippet'], auth: @auth
      end

      def list_params
        super.tap do |params|
          params[:params] = {maxResults: 50, part: 'snippet', mine: true}
        end
      end
    end
  end
end