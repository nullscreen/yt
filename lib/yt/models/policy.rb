require 'yt/models/base'
require 'yt/models/policy_rule'

module Yt
  module Models
    # Provides methods to interact with YouTube ContentID policies.
    # A policy resource specifies rules that define a particular usage or
    # match policy that a partner can associate with an asset or claim.
    # @see https://developers.google.com/youtube/partner/docs/v1/policies
    class Policy < Base
      def initialize(options = {})
        @data = options[:data]
      end

      # @return [String] the ID that YouTube assigns and uses to uniquely
      #   identify the policy.
      has_attribute :id

      # @return [String] the policy’s name.
      has_attribute :name

      # @return [String] the policy’s description.
      has_attribute :description

      # @return [String] the time the policy was updated.
      has_attribute :updated_at, type: Time, from: :time_updated

      # @return [Array<PolicyRule>] a list of rules that specify the action
      #   that YouTube should take and may optionally specify the conditions
      #   under which that action is enforced.
      has_attribute :rules do |rules|
        rules.map{|rule| PolicyRule.new data: rule}
      end
    end
  end
end