require 'yt/collections/base'
require 'yt/models/comment_thread'

module Yt
  module Collections
    # Provides methods to interact with a collection of YouTube commentThreads.
    #
    # !to work needs a force-ssl scope!
    #
    # Resources with comment threads are: {Yt::Models::Channel channels} and
    # {Yt::Models::Video videos}.
    class CommentThreads < Base


      private

        def attributes_for_new_item(data)
          {}.tap do |attributes|
            attributes[:id] = data['id']
            attributes[:top_level_comment] = data['snippet'].delete('topLevelComment') if data['snippet']
            attributes[:snippet] = data['snippet']
            attributes[:replies] = data['replies']
            attributes[:auth] = @auth
          end
        end


        # @return [Hash] the parameters to submit to YouTube to list commentThreads.
        # @see https://developers.google.com/youtube/v3/docs/commentThreads/list
        def list_params
          super.tap do |params|
            params[:params] = threads_params
          end
        end


        def threads_params
          params = {}
          params[:part] = 'snippet'
          params.merge! @parent.comments_params if @parent
          params
        end

    end

  end
end
