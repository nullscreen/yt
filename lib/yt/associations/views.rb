require 'yt/collections/views'

module Yt
  module Associations
    # Provides methods which allows to access the view count of a resource.
    #
    # YouTube resources with view counts are: {Yt::Models::Channel channels}.
    module Views
      # @return [Integer, nil] the view count for one specific day.
      # @param [Date or Time or DateTime or String] date The date to obtain
      #   the views for. If +String+, must be Date-parseable.
      def views_on(date)
        views(from: date, to: date).values.first
      end

      # @return [Hash] the view counts for a range of days. Each +key+ is a +Date+
      #   and each +value+ is an +Integer+ or +nil+, representing the number of views.
      # @param [Hash] options the range of days to get the view for.
      # @option options [Date or Time or DateTime or String] :since The start
      #   of the days range. If +String+, must be Date-parseable. Also aliased as *:from*.
      # @option options [Date or Time or DateTime or String] :until The end
      #   of the days range. If +String+, must be Date-parseable. Also aliased as *:to*.
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