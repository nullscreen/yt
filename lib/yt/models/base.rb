require 'yt/associations'
require 'yt/actions/delete'
require 'yt/actions/update'

module Yt
  class Base
    extend Associations
    include Actions::Delete
    include Actions::Update
  end
end