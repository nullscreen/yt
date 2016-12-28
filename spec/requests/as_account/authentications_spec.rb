require 'spec_helper'
require 'yt/models/account'

describe Yt::Account, :device_app do
  subject(:account) { Yt::Account.new attrs }

  describe '#refresh' do
    context 'given a valid refresh token' do
      let(:attrs) { {refresh_token: ENV['YT_TEST_DEVICE_REFRESH_TOKEN']} }

      # NOTE: When the token is refreshed, YouTube *might* actually return
      # the *same* access token if it is still valid. Typically, within the
      # same second, refreshing the token returns the same token. Still,
      # testing that *expires_at* changes is a guarantee that we attempted
      # to get a new token, which is what refresh is meant to do.
      it { expect{account.refreshed_access_token?}.to change{account.expires_at} }
    end
  end

  describe '#authentication' do
    context 'given a refresh token' do
      let(:attrs) { {refresh_token: refresh_token} }

      context 'that is valid' do
        let(:refresh_token) { ENV['YT_TEST_DEVICE_REFRESH_TOKEN'] }
        it { expect(account.authentication).to be_a Yt::Authentication }
        it { expect(account.refresh_token).to eq refresh_token }
      end

      context 'that is invalid' do
        let(:refresh_token) { '--not-a-valid-refresh-token--' }
        it { expect{account.authentication}.to raise_error Yt::Errors::Unauthorized }
      end
    end

    context 'given a redirect URI and an authorization code' do
      let(:attrs) { {authorization_code: authorization_code, redirect_uri: 'http://localhost/'} }

      context 'that is valid' do
        # cannot be tested "live"
      end

      context 'that is invalid' do
        let(:authorization_code) { rand(36**20).to_s(36) }
        it { expect{account.authentication}.to raise_error Yt::Errors::Unauthorized }
      end
    end

    context 'given an access token' do
      let(:attrs) { {access_token: access_token, expires_at: expires_at} }

      context 'that is valid' do
        let(:access_token) { $account.access_token }

        context 'that does not have an expiration date' do
          let(:expires_at) { nil }
          it { expect(account.authentication).to be_a Yt::Authentication }
        end

        context 'that has not expired' do
          let(:expires_at) { 1.day.from_now.to_s }
          it { expect(account.authentication).to be_a Yt::Authentication }
        end

        context 'that has expired' do
          let(:expires_at) { 1.day.ago.to_s }

          context 'and no refresh token' do
            it { expect{account.authentication}.to raise_error Yt::Errors::MissingAuth }
          end

          context 'and an invalid refresh token' do
            before { attrs[:refresh_token] = '--not-a-valid-refresh-token--' }
            it { expect{account.authentication}.to raise_error Yt::Errors::Unauthorized }
          end

          context 'and a valid refresh token' do
            before { attrs[:refresh_token] = ENV['YT_TEST_DEVICE_REFRESH_TOKEN'] }
            it { expect(account.authentication).to be_a Yt::Authentication }
          end
        end
      end

      context 'that is invalid' do
        let(:access_token) { '--not-a-valid-access-token--' }
        let(:expires_at) { 1.day.from_now }

        context 'and no refresh token' do
          it { expect{account.channel}.to raise_error Yt::Errors::Unauthorized }
        end

        context 'and a valid refresh token' do
          before { attrs[:refresh_token] = ENV['YT_TEST_DEVICE_REFRESH_TOKEN'] }
          it { expect{account.channel}.not_to raise_error }
        end
      end
    end

    context 'given scopes' do
      let(:attrs) { {scopes: ['userinfo.email', 'youtube']} }

      context 'and a redirect_uri' do
        before { attrs[:redirect_uri] = 'http://localhost/' }

        it { expect{account.authentication}.to raise_error Yt::Errors::MissingAuth }
      end
    end

    context 'given no token or code' do
      let(:attrs) { {} }
      it { expect{account.authentication}.to raise_error Yt::Errors::MissingAuth }
    end
  end

  describe '#authentication_url' do
    let(:auth_attrs) { {redirect_uri: 'http://localhost/', scopes: ['userinfo.email', 'userinfo.profile']} }
    context 'given a redirect URI and scopes' do
      let(:attrs) { auth_attrs }
      it { expect(account.authentication_url).to match 'access_type=offline' }

      context 'given a forced approval prompt' do
        let(:attrs) { auth_attrs.merge force: true }
        it { expect(account.authentication_url).to match 'approval_prompt=force' }
      end
    end
  end
end