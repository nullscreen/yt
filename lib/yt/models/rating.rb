require 'yt/models/base'

module Yt
  class Rating < Base
    attr_reader :rating

    def initialize(options = {})
      @rating = options[:rating].to_sym if options[:rating]
      @video_id = options[:video_id]
      @auth = options[:auth]
    end

    def update(new_rating)
      do_update(params: {rating: new_rating}) {@rating = new_rating}
    end

  private

    def update_params
      super.tap do |params|
        params[:method] = :post
        params[:path] = '/youtube/v3/videos/rate'
        params[:params] = {id: @video_id}
        params[:scope] = 'https://www.googleapis.com/auth/youtube'
      end
    end
  end
end