require 'yt/models/base'

module Yt
  module Models
    # Provides methods to interact with YouTube Analytics bulk reports.
    # @see https://developers.google.com/youtube/reporting/v1/reference/rest/v1/jobs.reports
    class BulkReport < Base
      # @private
      attr_reader :auth

      has_attribute :id
      has_attribute :start_time, type: Time
      has_attribute :end_time, type: Time
      has_attribute :download_url

      # @private
      def initialize(options = {})
        @data = options.fetch(:data, {})
        @auth = options[:auth]
      end
    end
  end
end
