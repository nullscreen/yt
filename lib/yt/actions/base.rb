module Yt
  module Actions
    # Abstract module that contains methods common to every action
    module Base

    private

      # If we dropped support for ActiveSupport 3, then we could simply
      # invoke transform_keys!{|key| key.to_s.underscore.to_sym}
      def underscore_keys!(hash)
        hash.dup.each_key{|key| hash[underscore key] = hash.delete key}
      end

      def underscore(value)
        value.to_s.underscore.to_sym
      end
    end
  end
end