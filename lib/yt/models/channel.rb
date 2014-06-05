require 'yt/models/resource'

module Yt
  module Models
    class Channel < Resource
      has_many :subscriptions
      has_many :videos
      has_many :playlists
      has_many :earnings
      has_many :views
    end
  end
end