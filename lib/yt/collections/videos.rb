require 'yt/collections/base'
require 'yt/models/video'

module Yt
  module Collections
    # Provides methods to interact with a collection of YouTube videos.
    #
    # Resources with videos are: {Yt::Models::Channel channels} and
    # {Yt::Models::Account accounts}.
    class Videos < Base

    private

      def attributes_for_new_item(data)
        id = use_list_endpoint? ? data['id'] : data['id']['videoId']
        snippet = data['snippet'].reverse_merge complete: false if data['snippet']
        {}.tap do |attributes|
          attributes[:id] = id
          attributes[:snippet] = snippet
          attributes[:status] = data['status']
          attributes[:content_details] = data['contentDetails']
          attributes[:statistics] = data['statistics']
          attributes[:video_category] = data['videoCategory']
          attributes[:claim] = data['claim']
          attributes[:auth] = @auth
        end
      end

      def eager_load_items_from(items)
        if included_relationships.any?
          associations = [:claim, :category]
          if (included_relationships & associations).any?
            included_relationships.append(:snippet).uniq!
          end

          ids = items.map{|item| item['id']['videoId']}
          parts = (included_relationships - associations).map do |r|
            r.to_s.camelize(:lower)
          end
          conditions = { id: ids.join(','), part: parts.join(',') }
          videos = Collections::Videos.new(auth: @auth).where conditions

          items.each do |item|
            video = videos.find{|v| v.id == item['id']['videoId']}
            parts.each do |part|
              item[part] = case part
                when 'snippet' then video.snippet.data.merge complete: true
                when 'status' then video.status.data
                when 'statistics' then video.statistics_set.data
                when 'contentDetails' then video.content_detail.data
              end
            end if video
          end

          if included_relationships.include? :claim
            video_ids = items.map{|item| item['id']['videoId']}.uniq
            conditions = {
              video_id: video_ids.join(','),
              include_third_party_claims: false
            }
            claims = @parent.claims.includes(:asset).where conditions
            items.each do |item|
              claim = claims.find { |c| c.video_id == item['id']['videoId']}
              item['claim'] = claim
            end
          end

          if included_relationships.include? :category
            category_ids = items.map{|item| item['snippet']['categoryId']}.uniq
            conditions = {id: category_ids.join(',')}
            video_categories = Collections::VideoCategories.new(auth: @auth).where conditions

            items.each do |item|
              video_category = video_categories.find{|v| v.id == item['snippet']['categoryId']}
              item['videoCategory'] = video_category.data
            end
          end
        end
        super
      end

      # @return [Hash] the parameters to submit to YouTube to list videos.
      # @see https://developers.google.com/youtube/v3/docs/search/list
      def list_params
        super.tap do |params|
          params[:params] = videos_params
          params[:path] = videos_path
        end
      end

      def videos_params
        {}.tap do |params|
          params[:type] = :video
          params[:max_results] = 50
          params[:part] = 'snippet'
          params[:order] = 'date'
          params.merge! @parent.videos_params if @parent
          apply_where_params! params
          params
        end
      end

      def videos_path
        use_list_endpoint? ? '/youtube/v3/videos' : '/youtube/v3/search'
      end

      # @private
      # YouTube API provides two different endpoints to get a list of videos:
      # /videos should be used when the query specifies video IDs or a chart,
      # /search otherwise.
      # @return [Boolean] whether to use the /videos endpoint.
      # @todo: This is one of three places outside of base.rb where @where_params
      #   is accessed; it should be replaced with a filter on params instead.
      def use_list_endpoint?
        @where_params ||= {}
        @parent.nil? && (@where_params.keys & [:id, :chart]).any?
      end
    end
  end
end
