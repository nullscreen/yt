require 'spec_helper'

describe Yt::Associations::PartneredChannels, :partner do
  describe '#partnered_channels' do
    let(:partnered_channels) { content_owner.partnered_channels }

    context 'given a content owner with partnered channels' do
      let(:content_owner) { $content_owner }

      it { expect(partnered_channels.count).to be > 0 }
      it { expect(partnered_channels.first).to be_a Yt::Channel }
    end
  end
end