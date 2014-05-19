require 'spec_helper'
require 'yt/associations/channels'

describe Yt::Associations::Channels, :device_app do
  describe '#channel' do
    it { expect($account.channel).to be_a Yt::Channel }
  end
end