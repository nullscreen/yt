require 'yt/collections/reports'

module Yt
  module Collections
    class Views < Reports

    private

      def metrics
        :views
      end

      def value_of(data)
        data.last.to_i if data.last
      end
    end
  end
end