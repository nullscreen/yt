require 'yt/config'
require 'yt/models/account'

RSpec.configure do |config|
  config.before :all, scenario: :device_app do
    unless Yt.configuration.scenario == :device_app
      Yt.configure do |config|
        config.scenario = :device_app
        config.client_id = ENV['YT_TEST_APP_DEVICE_CLIENT_ID']
        config.client_secret = ENV['YT_TEST_APP_DEVICE_CLIENT_SECRET']
        # Note: makes sure ALL the scopes are authorized in YT_TEST_DEVICE_REFRESH_TOKEN
        config.account = Yt::Account.new refresh_token: ENV['YT_TEST_DEVICE_REFRESH_TOKEN']
      end
    end
  end
end