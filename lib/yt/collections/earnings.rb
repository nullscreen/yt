require 'yt/collections/reports'

module Yt
  module Collections
    class Earnings < Reports

    private

      def metrics
        [:estimatedMinutesWatched, :earnings].join ','
      end
    end
  end
end