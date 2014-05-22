require 'yt/associations'
require 'yt/actions/delete'
require 'yt/actions/update'
require 'yt/errors/request_error'

module Yt
  module Models
    class Base
      extend Associations
      include Actions::Delete
      include Actions::Update
    end
  end

  include Models
end