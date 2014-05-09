require 'yt/config'

RSpec.configure do |config|
  config.before :all, scenario: :server_app do
    Yt.configure do |config|
      config.scenario = :server_app
      config.api_key = ENV['YT_TEST_APP_SERVER_API_KEY']
    end
  end
end