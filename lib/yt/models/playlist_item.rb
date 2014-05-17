require 'yt/models/base'

module Yt
  module Models
    class PlaylistItem < Base
      attr_reader :id, :video, :position

      def initialize(options = {})
        @id = options[:id]
        @auth = options[:auth]
        if options[:snippet]
          @position = options[:snippet]['position']
          @video = Video.new video_params_for options
        end
      end

      def delete
        do_delete {@id = nil}
        !exists?
      end

      def exists?
        !@id.nil?
      end

    private

      def delete_params
        super.tap do |params|
          params[:path] = '/youtube/v3/playlistItems'
          params[:params] = {id: @id}
        end
      end

      def video_params_for(options = {})
        {}.tap do |params|
          params[:id] = options[:snippet].fetch('resourceId', {})['videoId']
          params[:snippet] = options[:snippet].except 'resourceId'
          params[:auth] = options[:auth]
        end
      end
    end
  end
end