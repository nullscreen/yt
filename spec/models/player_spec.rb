require 'spec_helper'
require 'yt/models/player'

describe Yt::Player do
  subject(:player) { Yt::Player.new data: data }
  let(:value) { "<iframe type='text/html' src='http://www.youtube.com/embed/BPNYv0vd78A' width='640' height='360' frameborder='0' allowfullscreen='true'/>" }

  describe '#data' do
    let(:data) { {"key"=>"value"} }
    specify 'returns the data the player was initialized with' do
      expect(player.data).to eq data
    end
  end

  describe '#embed_html' do
    context 'given a video with embedHtml' do
      let(:data) { {"embedHtml"=>value} }
      it { expect(player.embed_html).to be value }
    end
  end
end