require 'yt/errors/base'

module Yt
  module Errors
    class MissingAuth < Base
      def message
        <<-MSG.gsub(/^ {6}/, '')
        Missing auth
        MSG
      end
    end
  end
end