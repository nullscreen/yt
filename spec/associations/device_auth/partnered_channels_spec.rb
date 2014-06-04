require 'spec_helper'

describe Yt::Associations::PartneredChannels, :partner do
  describe '#partnered_channels' do
    let(:partnered_channels) { content_owner.partnered_channels }

    context 'given a content owner with partnered channels' do
      let(:content_owner) { $content_owner }

      # NOTE: Uncomment once size does not runs through *all* the pages
      # it { expect(partnered_channels.size).to be > 0 }
      it { expect(partnered_channels.first).to be_a Yt::Channel }
    end
  end
end