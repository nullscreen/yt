require 'yt/actions/modify'

module Yt
  module Actions
    module Delete
      include Modify

    private

      def do_delete(extra_delete_params = {}, &block)
        do_modify delete_params.merge(extra_delete_params), &block
      end

      def delete_params
        modify_params.tap{|params| params[:method] = :delete}
      end
    end
  end
end