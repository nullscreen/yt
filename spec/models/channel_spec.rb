require 'spec_helper'
require 'yt/models/channel'

describe Yt::Channel do
  subject(:channel) { Yt::Channel.new attrs }

  describe '#snippet' do
    context 'given fetching a channel returns a snippet' do
      let(:attrs) { {snippet: {"title"=>"Fullscreen"}} }
      it { expect(channel.snippet).to be_a Yt::Snippet }
    end
  end
end