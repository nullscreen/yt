require 'yt/collections/user_infos'

module Yt
  module Associations
    # Provides the `has_one :user_info` method to YouTube resources, which
    # allows to access to user_info-specific methods like `email`.
    # YouTube resources with user infos are: accounts.
    module UserInfos
      def user_info
        @user_info ||= user_infos.first
      end

    private

      def user_infos
        @user_infos ||= Collections::UserInfos.by_account self
      end
    end
  end
end

