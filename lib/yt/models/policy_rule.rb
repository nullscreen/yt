require 'yt/models/base'

module Yt
  module Models
    # Provides methods to interact with YouTube ContentID policy rules.
    # Rules that specify the action that YouTube should take and may optionally
    # specify the conditions under which that action is enforced.
    # @see https://developers.google.com/youtube/partner/docs/v1/policies
    class PolicyRule < Base
      def initialize(options = {})
        @data = options[:data]
      end

      # Return the policy that YouTube should enforce if the rule’s conditions
      # are all valid for an asset or for an attempt to view that asset on
      # YouTube. Possible values are: +'block'+, +'monetize'+, +'takedown'+,
      # +'track'+.
      # @return [String] the policy that YouTube should enforce.
      has_attribute :action

      # @return [Array] A list of additional actions that YouTube should take if
      #   the conditions in the rule are met. Possible values are: +'review'+.
      has_attribute :subaction

      # Return the list of territories where the policy applies.
      # Each territory is an ISO 3166 two-letter country code.
      # YouTube determines whether the condition is satisfied based on the
      # user’s location.
      # @return [Array<String>] the territories where the policy applies.
      # @example (with 'block' action) only block a video for U.S. users:
      #   included_territories #=> ['us']
      def included_territories
        territories_type == 'include' ? territories : []
      end

      # Return the list of territories where the policy does not apply.
      # Each territory is an ISO 3166 two-letter country code.
      # YouTube determines whether the condition is satisfied based on the
      # user’s location.
      # @return [Array<String>] the territories where the policy does not apply.
      # @example (with 'block' action) only allow U.S. users to view a video:
      #   excluded_territories #=> ['us']
      def excluded_territories
        territories_type == 'exclude' ? territories : []
      end

      # @return [Array<Hash<Symbol, Float>>] the intervals of time the user-
      #   or partner-uploaded content needs to match a reference file for the
      #   rule to apply. :low is the minimum (inclusive) allowed value and
      #   :high is the maximum (inclusive) allowed value for the rule to apply.
      # @example videos that match the reference for 20 to 30 seconds:
      #   match_duration #= [{low: 20.0, high: 30.0}]
      def match_duration
        match_duration_list.map{|r| low_and_high r}
      end

      # @return [Array<Hash<Symbol, Float>>] the intervals of percentages the
      #   user- or partner-uploaded content needs to match a reference file for
      #   the rule to apply. :low is the minimum (inclusive) allowed value and
      #   :high is the maximum (inclusive) allowed value for the rule to apply.
      # @example videos that match the reference for 40%~50% of their duration:
      #   match_percent #= [{low: 40.0, high: 50.0}]
      def match_percent
        match_percent_list.map{|r| low_and_high r}
      end

      # @return [Array<Hash<Symbol, Float>>] the intervals of duration that the
      #   reference must have for the rule to apply. :low is the minimum
      #   (inclusive) allowed value, :high is the maximum (inclusive) allowed
      #   value for the rule to apply.
      # @example references that are between 20 and 30 seconds:
      #   reference_duration #= [{low: 20.0, high: 30.0}]
      def reference_duration
        reference_duration_list.map{|r| low_and_high r}
      end

      # @return [Array<Hash<Symbol, Float>>] the intervals of percentages the
      #   reference file needs to match the user- or partner-uploaded content
      #   for the rule to apply. :low is the minimum (inclusive) allowed value,
      #   :high is the maximum (inclusive) allowed value for the rule to apply.
      # @example videos that match either 0%~10% or 40%~50% of a reference:
      #   reference_percent #= [{low: 0.0, high: 10.0}, {low: 40.0, high: 50.0}]
      def reference_percent
        reference_percent_list.map{|r| low_and_high r}
      end

    private

      has_attribute :conditions, default: {}

      def territories_object
        conditions.fetch 'requiredTerritories', {}
      end

      def territories_type
        territories_object['type']
      end

      def territories
        territories_object['territories']
      end

      def match_duration_list
        conditions.fetch 'matchDuration', []
      end

      def match_percent_list
        conditions.fetch 'matchPercent', []
      end

      def reference_duration_list
        conditions.fetch 'referenceDuration', []
      end

      def reference_percent_list
        conditions.fetch 'referencePercent', []
      end

      def low_and_high(range)
        {low: range['low'], high: range['high']}
      end
    end
  end
end