require 'spec_helper'
require 'googol/google_account'

describe Googol::GoogleAccount do
  it 'provides a URL for users to authenticate' do
    expect(Googol::GoogleAccount.oauth_url).to be
  end

  context 'given a valid account authentication' do
    before :all do
      auth_params = {refresh_token: ENV['GOOGOL_TEST_GOOGLE_REFRESH_TOKEN']}
      @account = Googol::GoogleAccount.new auth_params
    end

    it {expect(@account.id).to be}
    it {expect(@account.email).to be}
    it {expect(@account.verified_email).to be}
    it {expect(@account.name).to be}
    it {expect(@account.given_name).to be}
    it {expect(@account.family_name).to be}
    it {expect(@account.link).to be}
    it {expect(@account.picture).to be}
    it {expect(@account.gender).to be}
    it {expect(@account.locale).to be}
    it {expect(@account.hd).to be}
  end

  context 'given a missing account authentication' do
    let(:account) { Googol::GoogleAccount.new }

    it {expect{account.id}.to raise_error Googol::RequestError}
  end

  context 'given an invalid authentication code' do
    let(:account) { Googol::GoogleAccount.new code: 'invalid' }

    it {expect{account.id}.to raise_error Googol::RequestError}
  end

  context 'given an invalid refresh token' do
    let(:account) { Googol::GoogleAccount.new refresh_token: 'invalid' }

    it {expect{account.id}.to raise_error Googol::RequestError}
  end
end