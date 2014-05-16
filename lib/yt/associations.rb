require 'active_support/core_ext/module/delegation'
require 'active_support/dependencies/autoload'
require 'active_support/core_ext/string/inflections' # for camelize

module Yt
  module Associations
    # @note: Using Autoload to avoid circular dependencies.
    #        For instance: Yt::Channel requires Yt::Base, which requires
    #        Yt::Associations, which requires Yt::Associations::Subscription,
    #        which requires Yt::Subscription, which requires Yt::Base
    extend ActiveSupport::Autoload

    autoload :Annotations
    autoload :Channels
    autoload :DetailsSets
    autoload :Ids
    autoload :PlaylistItems
    autoload :Playlists
    autoload :Ratings
    autoload :Snippets
    autoload :Statuses
    autoload :Subscriptions
    autoload :UserInfos
    autoload :Videos

    def has_many(attributes, options = {})
      mod = attributes.to_s.sub(/.*\./, '').camelize
      include "Yt::Associations::#{mod.pluralize}".constantize
      delegate *options[:delegate], to: attributes if options[:delegate]
    end

    alias has_one has_many
  end
end