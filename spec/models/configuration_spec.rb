require 'spec_helper'

describe Yt::Configuration do
  subject(:config) { Yt::Configuration.new }

  describe '#scenario' do
    context 'by default' do
      it {expect(config.scenario).to be :web_app }
    end

    context 'given an invalid environment variable YT_CLIENT_SCENARIO' do
      before { ENV['YT_CLIENT_SCENARIO'] = 'not-a-scenario'}
      it {expect(config.scenario).to be :web_app }
    end

    context 'given a valid environment variable YT_CLIENT_SCENARIO' do
      before { ENV['YT_CLIENT_SCENARIO'] = 'device_app'}
      it {expect(config.scenario).to be :device_app }
    end
  end

  describe '#client_id' do
    context 'by default' do
      it {expect(config.client_id).to be_nil }
    end

    context 'given an environment variable YT_CLIENT_ID' do
      let(:client_id) { '1234567890.apps.googleusercontent.com' }
      before { ENV['YT_CLIENT_ID'] = client_id}
      it {expect(config.client_id).to eq client_id }
    end
  end

  describe '#client_secret' do
    context 'by default' do
      it {expect(config.client_secret).to be_nil }
    end

    context 'given an environment variable YT_CLIENT_SECRET' do
      let(:client_secret) { '1234567890' }
      before { ENV['YT_CLIENT_SECRET'] = client_secret}
      it {expect(config.client_secret).to eq client_secret }
    end
  end

  describe '#api_key' do
    context 'by default' do
      it {expect(config.api_key).to be_nil }
    end

    context 'given an environment variable YT_API_KEY' do
      let(:api_key) { '123456789012345678901234567890' }
      before { ENV['YT_API_KEY'] = api_key}
      it {expect(config.api_key).to eq api_key }
    end
  end
end