require 'yt/models/base'

module Yt
  module Models
    # @private
    # Provides methods to modify the rating of a video on YouTube.
    # @see https://developers.google.com/youtube/v3/docs/videos/rate
    # @see https://developers.google.com/youtube/v3/docs/videos/getRating
    class Rating < Base
      # @return [Symbol, nil] the rating of a video (if present).
      #  Possible values are: +:dislike+, +:like+, +:none+, +:unspecified+.
      attr_reader :rating

      def initialize(options = {})
        @rating = options[:rating].to_sym if options[:rating]
        @video_id = options[:video_id]
        @auth = options[:auth]
      end

      def set(new_rating)
        do_update(params: {rating: new_rating}) {@rating = new_rating}
      end

    private

      # @return [Hash] the parameters to submit to YouTube to update a rating.
      # @see https://developers.google.com/youtube/v3/docs/videos/rate
      def update_params
        super.tap do |params|
          params[:method] = :post
          params[:path] = '/youtube/v3/videos/rate'
          params[:params] = {id: @video_id}
        end
      end
    end
  end
end