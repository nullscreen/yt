require 'yt/collections/authentications'
require 'yt/config'

module Yt
  module Associations
    # Provides the `has_one :access_token` method to YouTube resources, which
    # allows to access to content detail set-specific methods like `access_token`.
    # YouTube resources with access tokens are: accounts.
    module Authentications
      def authentication
        @authentication ||= authentications.first!
      end

      def authentication_params
        {}.tap do |params|
          params[:client_id] = client_id
          params[:client_secret] = client_secret
          params[:refresh_token] = @refresh_token
          params[:grant_type] = :refresh_token
        end
      end

    private

      def authentications
        @authentications ||= Collections::Authentications.of self
      end

      def client_id
        Yt.configuration.client_id
      end

      def client_secret
        Yt.configuration.client_secret
      end
    end
  end
end