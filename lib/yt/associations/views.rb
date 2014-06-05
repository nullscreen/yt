require 'yt/collections/views'

module Yt
  module Associations
    # Provides the `has_many :views` method to YouTube resources, which
    # allows to invoke view-related methods, such as .views.
    # YouTube resources with views are: channels.
    module Views
      # Return the view count for one specific day.
      #
      # @param [Date or Time or DateTime or String] date The date to obtain
      # the estimated views for. If String, must be Date-parseable.
      #
      # @return [Integer or Nil] The estimated views.
      def views_on(date)
        views(from: date, to: date).values.first
      end

      # Return the view count for a range of days.
      #
      # @param [Hash] options the range of days to get the views for.
      # @option options [Date or Time or DateTime or String] :since The start
      # of the days range. If String, must be Date-parseable.
      # @note options[:since] is aliased as options[:from]
      # @option options [Date or Time or DateTime or String] :until The end
      # of the days range. If String, must be Date-parseable.
      # @note options[:until] is aliased as options[:to]
      #
      # @return [Hash] The view count by day. Each :key is a Date
      # and each :value is an Integer or nil, representing the number of views.
      def views(options = {})
        from = options[:since] || options[:from] || 5.days.ago
        to = options[:until] || options[:to] || 1.day.ago
        range = Range.new *[from, to].map(&:to_date)

        Hash[*range.flat_map do |date|
          [date, (@views ||= {})[date] ||= range_views(range)[date]]
        end]
      end

    private

      def range_views(date_range)
        (@range_views ||= {})[date_range] ||= all_views.within date_range
      end

      def all_views
        Collections::Views.of self
      end
    end
  end
end