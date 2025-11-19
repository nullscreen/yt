require 'spec_helper'
require 'yt/models/channel_section'

describe Yt::ChannelSection do
  subject(:channel_section) { Yt::ChannelSection.new attrs }

  describe '#position' do
    context 'given fetching a channel_section returns a snippet' do
      let(:attrs) { {snippet: {"title"=>"New Section", "position"=>0}} }
      it { expect(channel_section.position).to eq 0 }
    end
  end
end
