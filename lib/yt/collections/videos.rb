require 'yt/collections/base'
require 'yt/models/video'

module Yt
  module Collections
    class Videos < Base

      def initialize(options = {})
        @channel = options[:channel]
        @auth = options[:auth]
      end

      def self.by_channel(channel)
        new channel: channel, auth: channel.auth
      end

    private

      def new_item(data)
        Yt::Video.new id: data['id']['videoId'], snippet: data['snippet'], auth: @auth
      end

      def list_params
        super.tap do |params|
          params[:params] = {channelId: @channel.id, type: :video, maxResults: 50, part: 'snippet'}
          params[:scope] = 'https://www.googleapis.com/auth/youtube'
          params[:path] = '/youtube/v3/search'
        end
      end
    end
  end
end