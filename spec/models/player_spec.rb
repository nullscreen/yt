require 'spec_helper'
require 'yt/models/player'

describe Yt::Player do
  subject(:player) { Yt::Player.new data: data }

  describe '#data' do
    let(:data) { {"key"=>"value"} }
    specify 'returns the data the player was initialized with' do
      expect(player.data).to eq data
    end
  end
end