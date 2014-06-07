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
    autoload :Authentications
    autoload :Channels
    autoload :DetailsSets
    autoload :Earnings
    autoload :Ids
    autoload :PartneredChannels
    autoload :PlaylistItems
    autoload :Playlists
    autoload :Ratings
    autoload :Snippets
    autoload :Statuses
    autoload :Subscriptions
    autoload :UserInfos
    autoload :Videos
    autoload :Views

    def has_many(attributes, options = {})
      mod = attributes.to_s.sub(/.*\./, '').camelize
      include "Yt::Associations::#{mod.pluralize}".constantize
      delegate *options[:delegate], to: attributes if options[:delegate]
    end


    def has_one(attribute, options = {})
      delegate *options[:delegate], to: attribute if options[:delegate]

      attributes = attribute.to_s.pluralize
      require "yt/collections/#{attributes}"
      mod = attributes.sub(/.*\./, '').camelize
      collection = "Yt::Collections::#{mod.pluralize}".constantize

      define_method attribute do
        ivar = instance_variable_get "@#{attribute}"
        instance_variable_set "@#{attribute}", ivar || send(attributes).first!
      end

      define_method attributes do
        ivar = instance_variable_get "@#{attributes}"
        instance_variable_set "@#{attributes}", ivar || collection.of(self)
      end
    end
  end
end