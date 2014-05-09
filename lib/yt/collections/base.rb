require 'yt/actions/delete_all'
require 'yt/actions/insert'
require 'yt/actions/list'

module Yt
  module Collections
    class Base
      include Actions::DeleteAll
      include Actions::Insert
      include Actions::List
    end
  end
end