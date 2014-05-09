require 'yt/collections/base'
require 'yt/models/channel'

module Yt
  module Collections
    class Channels < Base

      def initialize(options = {})
        @account = options[:account]
        @auth = options[:auth]
      end

      def self.by_account(account)
        new account: account, auth: account.auth
      end

    private

      def new_item(data)
        Yt::Channel.new id: data['id'], snippet: data['snippet'], auth: @auth
      end

      def list_params
        super.tap do |params|
          params[:params] = {maxResults: 50, part: 'snippet', mine: true}
          params[:scope] = 'https://www.googleapis.com/auth/youtube'
          params[:path] = '/youtube/v3/channels'
        end
      end
    end
  end
end