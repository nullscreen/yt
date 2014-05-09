require 'yt/utils/request'

module Yt
  module Actions
    module List

      delegate :count, :first, :any?, :each, :map, :find, to: :list
      alias size count

    private

      def list
        @last_index, @page_token = 0, nil
        Enumerator.new do |items|
          while next_item = find_next
            items << next_item
          end
        end
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
        params[:params][:pageToken] = @page_token if @page_token
        next_page = fetch_page params
        @page_token = next_page[:token]
        next_page[:items]
      end

      def fetch_page(params = {})
        request = Request.new params
        response = request.run
        raise unless response.is_a? Net::HTTPOK
        token = response.body['nextPageToken']
        items = response.body.fetch 'items', []
        {items: items, token: token}
      end

      def list_params
        {}.tap do |params|
          params[:method] = :get
          params[:format] = :json
          params[:host] = 'www.googleapis.com'
          params[:auth] = @auth
        end
      end
    end
  end
end