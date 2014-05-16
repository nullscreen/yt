require 'spec_helper'
require 'yt/associations/user_infos'

describe Yt::Associations::UserInfos, scenario: :device_app do
  subject(:account) { Yt::Account.new attrs }

  describe '#user_info' do
    context 'given an existing account' do
      let(:account) { Yt.configuration.account }
      it { expect(account.user_info).to be_a Yt::UserInfo }
    end

    # Note: testing with an unknown account would fail before getting user info
  end
end