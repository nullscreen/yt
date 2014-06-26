require 'yt/collections/authentications'
require 'yt/config'
require 'yt/errors/no_items'
require 'yt/errors/unauthorized'

module Yt
  module Modules
    # Provides methods to to access the analytics reports of a resource.
    #
    # YouTube resources with reports are: {Yt::Models::Channel channels}.
    module Reports
      # @private
      # @example The following adds the +earnings+ and +earnings_on+ methods
      #   to every channel to ease the access to its estimated daily earnings.
      #
      #   class Channel < Resource
      #     has_report :earnings
      #   end
      def has_report(metric)
        define_method "#{metric}_on" do |date|
          send(metric, from: date, to: date).values.first
        end

        define_method metric do |options = {}|
          from = options[:since] || options[:from] || 5.days.ago
          to = options[:until] || options[:to] || 1.day.ago
          range = Range.new *[from, to].map(&:to_date)

          ivar = instance_variable_get "@#{metric}"
          instance_variable_set "@#{metric}", ivar || {}

          Hash[*range.flat_map do |date|
            [date, instance_variable_get("@#{metric}")[date] ||= send("range_#{metric}", range)[date]]
          end]
        end

        define_method "range_#{metric}" do |date_range|
          ivar = instance_variable_get "@range_#{metric}"
          instance_variable_set "@range_#{metric}", ivar || {}
          instance_variable_get("@range_#{metric}")[date_range] ||= send("all_#{metric}").within date_range
        end

        private "range_#{metric}"

        define_method "all_#{metric}" do
          require "yt/collections/#{metric}"
          mod = metric.to_s.sub(/.*\./, '').camelize
          collection = "Yt::Collections::#{mod.pluralize}".constantize
          collection.of self
        end

        private "all_#{metric}"
      end
    end
  end
end