require 'yt/models/resource'

module Yt
  module Models
    class Video < Resource
      has_one :details_set, delegate: [:duration]
      has_one :rating
      has_many :annotations
    end
  end
end