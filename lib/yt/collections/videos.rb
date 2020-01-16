require 'yt/collections/base'
require 'yt/models/video'

module Yt
  module Collections
    # Provides methods to interact with a collection of YouTube videos.
    #
    # Resources with videos are: {Yt::Models::Channel channels} and
    # {Yt::Models::Account accounts}.
    class Videos < Base
      def where(requirements = {})
        @published_before = nil
        @halt_list = false
        super
      end

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

      def next_page
        super.tap do |items|
          halt_list if use_list_endpoint? && items.empty? && @page_token.nil?
          add_offset_to(items) if !use_list_endpoint? && videos_params[:order] == 'date' && !(videos_params[:for_mine] || videos_params[:for_content_owner])
        end
      end

      # According to http://stackoverflow.com/a/23256768 YouTube does not
      # provide more than 500 results for any query. In order to overcome
      # that limit, the query is restarted with a publishedBefore filter in
      # case there are more videos to be listed for a channel
      def add_offset_to(items)
        @fetched_items ||= 0
        if (@fetched_items += items.count) >= 500
          last_published = items.last['snippet']['publishedAt']
          last_published = DateTime.rfc3339(last_published) - 1.second
          last_published = last_published.strftime '%FT%T.999Z'
          @page_token, @published_before, @fetched_items = '', last_published, 0
        elsif (1...50) === @last_index % 50
          @halt_list, @page_token = true, nil
          @last_index += items.size
        end
      end

      # If we ask for a list of videos matching specific IDs and no video is
      # returned (e.g. they are all private/deleted), then we don’t want to
      # switch from /videos to /search and keep on looking for videos, but
      # simply return an empty array of items
      def halt_list
        @halt_list = true
      end

      def more_pages?
        (@last_index.zero? && !@halt_list) || !@page_token.nil?
      end

      def videos_params
        {}.tap do |params|
          params[:type] = :video
          params[:max_results] = 50
          params[:part] = 'snippet'
          params[:order] = 'date'
          params.merge! @parent.videos_params if @parent
          apply_where_params! params
          params[:published_before] = @published_before if @published_before
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
