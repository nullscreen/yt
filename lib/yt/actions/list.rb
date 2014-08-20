require 'yt/models/request'
require 'yt/models/iterator'
require 'yt/errors/no_items'

module Yt
  module Actions
    module List
      delegate :count, :first, :any?, :each, :map, :flat_map, :find,
        :size, to: :list

      def first!
        first.tap{|item| raise Errors::NoItems, last_request unless item}
      end

    private

      def list
        @last_index, @page_token = 0, nil
        Yt::Iterator.new(-> {total_results}) do |items|
          while next_item = find_next
            items << next_item
          end
          @where_params = {}
        end
      end

      # @private
      # Returns the total number of items that YouTube can provide for the
      # given request, either all in one page or in consecutive pages.
      def total_results
        response = request(list_params).run
        total_results = response.body.fetch('pageInfo', {})['totalResults']
        total_results ||= response.body.fetch(items_key, []).size
      end

      def find_next
        @items ||= []
        if @items[@last_index].nil? && more_pages?
          more_items = next_page.map{|data| new_item data}
          @items.concat more_items
        end
        @items[(@last_index +=1) -1]
      end

      # To be overriden by the subclasses
      def new_item(data)
      end

      def more_pages?
        @last_index.zero? || !@page_token.nil?
      end

      def next_page
        params = list_params.dup
        params[:params][:page_token] = @page_token if @page_token
        next_page = fetch_page params
        @page_token = next_page[:token]
        next_page[:items]
      end

      def fetch_page(params = {})
        response = request(params).run
        token = response.body['nextPageToken']
        items = response.body.fetch items_key, []
        {items: items, token: token}
      end

      def request(params = {})
        @last_request = Yt::Request.new params
      end

      def last_request
        @last_request.request_error_message if @last_request
      end

      def list_params
        path = "/youtube/v3/#{list_resources.to_s.demodulize.camelize :lower}"

        {}.tap do |params|
          params[:method] = :get
          params[:auth] = @auth
          params[:path] = path
          params[:exptected_response] = Net::HTTPOK
        end
      end

      def items_key
        'items'
      end

      def list_resources
        self.class
      end
    end
  end
end