require 'yt/models/resource'

module Yt
  module Models
    class Channel < Resource
      has_many :subscriptions
      has_many :videos
      has_many :playlists
      has_many :earnings # requires auth with an account with 'yt-analytics-monetary.readonly'
    end
  end
end