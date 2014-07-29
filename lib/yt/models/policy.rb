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
      def id
        @id ||= @data['id']
      end

      # @return [String] the policy’s name.
      def name
        @name ||= @data['name']
      end

      # @return [String] the policy’s description.
      def description
        @name ||= @data['description']
      end

      # @return [String] the time the policy was updated.
      def time_updated
        @time_updated ||= Time.parse @data['timeUpdated']
      end

      # @return [Array<PolicyRule>] a list of rules that specify the action
      #   that YouTube should take and may optionally specify the conditions
      #   under which that action is enforced.
      def rules
        @rules ||= @data['rules'].map{|rule| PolicyRule.new data: rule}
      end
    end
  end
end