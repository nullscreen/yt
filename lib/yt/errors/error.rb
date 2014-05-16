require 'yt/errors/base'

# Just an alias in the main namespace, so external code can `rescue Yt::Error`
# rather than `rescue Yt::Error::Base`
module Yt
  class Error < Errors::Base
  end
end