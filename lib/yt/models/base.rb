require 'yt/actions/delete'
require 'yt/actions/update'
require 'yt/modules/associations'
require 'yt/errors/request_error'

module Yt
  module Models
    class Base
      extend Modules::Associations

      include Actions::Delete
      include Actions::Update
    end
  end

  # By including Models in the main namespace, models can be initialized with
  # the shorter notation Yt::Video.new, rather than Yt::Models::Video.new.
  include Models
end