require 'yt/collections/earnings'

module Yt
  module Associations
    # Provides the `has_many :earnings` method to YouTube resources, which
    # allows to invoke earning-related methods, such as .earnings.
    # YouTube resources with earning are: channels.
    module Earnings
      # Return the estimated earnings for one specific day.
      #
      # @param [Date or Time or DateTime or String] date The date to obtain
      # the estimated earnings for. If String, must be Date-parseable.
      #
      # @return [Float] The estimated earnings in USD.
      def earnings_on(date)
        earnings(from: date, to: date).values.first
      end

      # Return the estimated earnings for a range of days.
      #
      # @param [Hash] options the range of days to get the earnings for.
      # @option options [Date or Time or DateTime or String] :since The start
      # of the days range. If String, must be Date-parseable.
      # @note options[:since] is aliased as options[:from]
      # @option options [Date or Time or DateTime or String] :until The end
      # of the days range. If String, must be Date-parseable.
      # @note options[:until] is aliased as options[:to]
      #
      # @return [Hash] The estimated earnings by day. Each :key is a Date
      # and each :value is a Float, representing estimated earnings in USD.
      def earnings(options = {})
        from = options[:since] || options[:from] || 6.days.ago
        to = options[:until] || options[:to] || 2.days.ago
        range = Range.new *[from, to].map(&:to_date)

        Hash[*range.flat_map do |date|
          [date, (@earnings ||= {})[date] ||= range_earnings(range)[date]]
        end]
      end

    private

      def range_earnings(date_range)
        (@range_earnings ||= {})[date_range] ||= all_earnings.within date_range
      end

      def all_earnings
        Collections::Earnings.of self
      end
    end
  end
end