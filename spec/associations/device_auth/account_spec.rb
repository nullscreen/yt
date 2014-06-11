require 'spec_helper'
require 'yt/models/account'

describe Yt::Account, :device_app do
  describe '.channel' do
    it { expect($account.channel).to be_a Yt::Channel }
  end

  describe '.user_info' do
    it { expect($account.user_info).to be_a Yt::UserInfo }
  end

  describe '.videos' do
    it { expect($account.videos).to be_a Yt::Collections::Videos }
    it { expect($account.videos.first).to be_a Yt::Video }
  end
end