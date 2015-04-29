module Yt
  module Associations
    # Provides methods to access the viewer percentage reports of a resource.
    #
    # YouTube resources with viewer percentage reports are:
    # {Yt::Models::Channel channels} and {Yt::Models::Channel videos}.
    # @deprecated
    module HasViewerPercentages
      # @!macro has_viewer_percentages
      #   @deprecated
      #   @!method viewer_percentages
      #     @return [Hash<Symbol,Hash<String,Float>>] the viewer percentages.
      #       The first-level hash identifies the genres (:female, :male).
      #       The second-level hash identifies the age ranges ('18-24',
      #       '25-34', '35-44', '45-54', '55-64', '65-')
      #     @example Return the % of male viewers of a channel older than 64
      #       channel.viewer_percentages[:male]['65-'] #=> 12.02

      # Defines one public instance methods to access the viewer percentages of
      # a resource for a specific metric.
      # @example Adds +viewer_percentages+ and +viewer_percentage+ on Channel.
      #   class Channel < Resource
      #     has_viewer_percentages
      #   end
      def has_viewer_percentages
        require 'yt/collections/viewer_percentages'

        define_viewer_percentages_method
      end

    private

      def define_viewer_percentages_method
        define_method :viewer_percentages do
          @viewer_percentages ||= Collections::ViewerPercentages.of(self)[id]
        end
      end
    end
  end
end