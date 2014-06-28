require 'yt/actions/modify'

module Yt
  module Actions
    module Update
      include Modify

    private

      def do_update(extra_update_params = {}, &block)
        do_modify update_params.deep_merge(extra_update_params), &block
      end

      def update_params
        modify_params.tap{|params| params[:method] = :put}
      end
    end
  end
end