require 'spec_helper'
require 'yt/models/account'

describe Yt::Account, :device_app do
  it { expect($account.channel).to be_a Yt::Channel }
  it { expect($account.user_info).to be_a Yt::UserInfo }
end