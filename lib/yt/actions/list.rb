require 'yt/request'
require 'yt/models/iterator'
require 'yt/errors/no_items'
require 'yt/config'

module Yt
  module Actions
    module List
      delegate :any?, :count, :each, :each_cons, :each_slice, :find, :first, :take,
        :flat_map, :map, :select, :size, to: :list

      def first!
        first.tap{|item| raise Errors::NoItems, error_message unless item}
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

      # Returns the total number of items that YouTube can provide for the
      # given request, either all in one page or in consecutive pages.
      #
      # This number comes from the 'totalResults' component of the 'pageInfo'
      # which, accordingly to YouTube documentation, *does not always match
      # the actual number of items in the response*.
      #
      # For instance, when retrieving a list of channels, 'totalResults' might
      # include inactive channels, which are filtered out from the response.
      #
      # The only way to obtain the *real* number of returned items is to
      # iterate through all the pages, which can results in many requests.
      # To avoid this, +total_results+ is provided as a good size estimation.
      def total_results
        response = list_request(list_params).run
        total_results = response.body.fetch('pageInfo', {})['totalResults']
        total_results ||= extract_items(response.body).size
      end

      def find_next
        @items ||= []
        if @items[@last_index].nil? && more_pages?
          more_items = next_page.map{|data| new_item data}.compact
          @items.concat more_items
        end
        @items[(@last_index +=1) -1]
      end

      def resource_class
        resource_name = list_resources.singularize
        require "yt/models/#{resource_name.underscore}"
        "Yt::Models::#{resource_name}".constantize
      end

      # @return [resource_class] a new resource initialized with one
      #   of the items returned by asking YouTube for a list of resources.
      #   Can be overwritten by subclasses that initialize instance with
      #   a different set of parameters.
      def new_item(data)
        resource_class.new attributes_for_new_item(data)
      end

      # @private
      # Can be overwritten by subclasses that initialize instance with
      # a different set of parameters.
      def attributes_for_new_item(data)
        {data: data, auth: @auth}
      end

      def more_pages?
        @last_index.zero? || @page_token.present?
      end

      def next_page
        params = list_params.dup
        params[:params][:page_token] = @page_token if @page_token
        next_page = fetch_page params
        @page_token = next_page[:token]
        eager_load_items_from next_page[:items]
      end

      def eager_load_items_from(items)
        items
      end

      def fetch_page(params = {})
        @last_response = list_request(params).run
        token = @last_response.body['nextPageToken']
        items = extract_items @last_response.body
        {items: items, token: token}
      end

      def list_request(params = {})
        @list_request = Yt::Request.new(params).tap do |request|
          print "#{request.as_curl}\n" if Yt.configuration.developing?
        end
      end

      def error_message
        {}.tap do |message|
          message[:request_curl] = @list_request.as_curl
          message[:response_body] = JSON(@last_response.body)
        end.to_json if @list_request && @last_response
      end

      def list_params
        path = "/youtube/v3/#{list_resources.camelize :lower}"

        {}.tap do |params|
          params[:method] = :get
          params[:host] = 'www.googleapis.com'
          params[:auth] = @auth
          params[:path] = path
          params[:exptected_response] = Net::HTTPOK
          params[:api_key] = Yt.configuration.api_key if Yt.configuration.api_key
        end
      end

      def extract_items(list)
        list.fetch items_key, []
      end

      def items_key
        'items'
      end

      def list_resources
        self.class.to_s.demodulize
      end
    end
  end
end
