require 'yt/actions/delete'
require 'yt/actions/update'
require 'yt/actions/patch'

require 'yt/associations/has_authentication'
require 'yt/associations/has_many'
require 'yt/associations/has_one'
require 'yt/associations/has_reports'
require 'yt/associations/has_viewer_percentages'

require 'yt/errors/request_error'

module Yt
  module Models
    class Base
      include Actions::Delete
      include Actions::Update
      include Actions::Patch

      extend Associations::HasReports
      extend Associations::HasViewerPercentages
      extend Associations::HasOne
      extend Associations::HasMany
      extend Associations::HasAuthentication

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

  # By including Models in the main namespace, models can be initialized with
  # the shorter notation Yt::Video.new, rather than Yt::Models::Video.new.
  include Models
end