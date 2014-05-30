require 'yt/config'
require 'yt/models/account'

RSpec.configure do |config|
  # Create one global test account to avoid having to refresh the access token
  # at every request
  config.before :all do
    attrs = {refresh_token: ENV['YT_TEST_DEVICE_REFRESH_TOKEN']}
    $account = Yt::Account.new attrs
  end

  # Don't use authentication from env variables unless specified with a tag
  config.before :all do
    Yt.configure do |config|
      config.client_id = nil
      config.client_secret = nil
      config.api_key = nil
    end
  end

  config.before :all, device_app: true do
    Yt.configure do |config|
      config.client_id = ENV['YT_TEST_DEVICE_CLIENT_ID']
      config.client_secret = ENV['YT_TEST_DEVICE_CLIENT_SECRET']
    end
  end

  config.before :all, server_app: true do
    Yt.configure do |config|
      config.api_key = ENV['YT_TEST_SERVER_API_KEY']
    end
  end

  config.before :all, partner: true do
    Yt.configure do |config|
      config.client_id = ENV['YT_TEST_PARTNER_CLIENT_ID']
      config.client_secret = ENV['YT_TEST_PARTNER_CLIENT_SECRET']
    end
    # Create one Youtube Partner channel, authenticated as the content owner
    attrs = {refresh_token: ENV['YT_TEST_CONTENT_OWNER_REFRESH_TOKEN']}
    attrs[:owner_name] = ENV['YT_TEST_CONTENT_OWNER_NAME']
    content_owner = Yt::Account.new attrs
    attrs = {id: ENV['YT_TEST_PARTNER_CHANNEL_ID'], auth: content_owner}
    $partner_channel = Yt::Channel.new attrs
  end
end