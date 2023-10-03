require 'yt/models/resource'

module Yt
  module Models
    # Provides methods to interact with YouTube video captions.
    # @see https://developers.google.com/youtube/v3/docs/captions
    class Caption < Resource

      # @return [String] the ID used to identify the caption.
      has_attribute :id

      delegate :video_id, to: :snippet
      delegate :last_updated, to: :snippet
      delegate :language, to: :snippet
      delegate :name, to: :snippet
      delegate :status, to: :snippet
    end
  end
end
