require 'spec_helper'
require 'yt/associations/channels'

describe Yt::Associations::Channels, scenario: :device_app do
  let(:account) { Yt.configuration.account }

  describe '#channel' do
    it { require 'pry'; binding.pry; true; expect(account.channel).to be_a Yt::Channel }
  end
end