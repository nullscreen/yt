require 'spec_helper'
require 'yt/associations/user_infos'

describe Yt::Associations::UserInfos, scenario: :device_app do
  let(:account) { Yt.configuration.account }

  describe '#user_info' do
    it { expect(account.user_info).to be_a Yt::UserInfo }
  end
end