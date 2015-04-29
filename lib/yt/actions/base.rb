# encoding: UTF-8
module Yt
  # @private
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

      # @return [Hash] the original hash with angle brackets characters in its
      #   values replaced with similar Unicode characters accepted by Youtube.
      # @see https://support.google.com/youtube/answer/57404?hl=en
      def sanitize_brackets!(source)
        case source
          when String then source.gsub('<', '‹').gsub('>', '›')
          when Array then source.map{|string| sanitize_brackets! string}
          when Hash then source.each{|k,v| source[k] = sanitize_brackets! v}
        end
      end
    end
  end
end