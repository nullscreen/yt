require 'yt/config'
require 'yt/models/account'

module Helpers
  def test_account
    @test_account ||= Yt::Account.new(refresh_token: ENV['YT_TEST_REFRESH_TOKEN'])
  end
end

RSpec.configure do |config|
  config.include Helpers

  config.before :each do
    allow(Yt).to receive(:configuration).and_return(Yt::Configuration.new)
    allow(Yt.configuration).to receive(:api_key).and_return(nil)
  end

  config.before :each, device_app: true do
    allow(Yt.configuration).to receive(:client_id).and_return(ENV['YT_TEST_CLIENT_ID'])
    allow(Yt.configuration).to receive(:client_secret).and_return(ENV['YT_TEST_CLIENT_SECRET'])
  end

  config.before :each, server_app: true do
    allow(Yt.configuration).to receive(:api_key).and_return(ENV['YT_TEST_API_KEY'])
  end
end
