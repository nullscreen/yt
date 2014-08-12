require 'yt/models/base'
require 'yt/models/asset_match_policy'

module Yt
  module Models
    # Provides methods to interact with YouTube ContentID assets.
    # @see https://developers.google.com/youtube/partner/docs/v1/assets
    class Asset < Base
      def initialize(options = {})
        @data = options[:data]
        @auth = options[:auth]
      end

      # @return [String] the ID that YouTube assigns and uses to uniquely
      #   identify the asset.
      def id
        @id ||= @data['id']
      end

      # @return [AssetMatchPolicy] the match policy set by the default
      #   content owner for the currently authenticated user.
      def match_policy
        @asset_match_policy ||= if @data['matchPolicy']
          AssetMatchPolicy.new data: @data['matchPolicy'], asset_id: id, auth: @auth
        end
      end

# Type

      TYPES = %q(art_track_video composition episode general movie music_video season show sound_recording video_game web)

      # @return [String] the asset's type. Valid values are: art_track_video
      #   composition, episode, general, movie, music_video, season
      #   show sound_recording, video_game, web
      def type
        @type ||= @data["type"]
      end

      # @return [Boolean] whether the asset is of type art_track_video
      def art_track_video?
        type == 'art_track_video'
      end

      # @return [Boolean] whether the asset is of type art_track_video
      def composition?
        type == 'composition'
      end

      # @return [Boolean] whether the asset is of type episode
      def episode?
        type == 'episode'
      end

      # @return [Boolean] whether the asset is of type general
      def general?
        type == 'general'
      end

      # @return [Boolean] whether the asset is of type movie
      def movie?
        type == 'movie'
      end

      # @return [Boolean] whether the asset is of type music_video
      def music_video?
        type == 'music_video'
      end

      # @return [Boolean] whether the asset is of type season
      def season?
        type == 'season'
      end

      # @return [Boolean] whether the asset is of type show
      def show?
        type == 'show'
      end

      # @return [Boolean] whether the asset is of type sound_recording
      def sound_recording?
        type == 'sound_recording'
      end

      # @return [Boolean] whether the asset is of type video_game
      def video_game?
        type == 'video_game'
      end

      # @return [Boolean] whether the asset is of type web
      def web?
        type == 'web'
      end

# Status

      STATUSES = %q(active inactive pending)

      # @return [String] the asset's status. Valid values are: active,
      #    inactive, pending
      def status
        @status ||= @data["status"]
      end

      # @return [Boolean] whether the asset is active.
      def active?
        status == 'active'
      end

      # @return [Boolean] whether the asset is inactive.
      def inactive?
        status == 'inactive'
      end

      # @return [Boolean] whether the asset is pending.
      def pending?
        status == 'pending'
      end

    end
  end
end