require 'spec_helper'
require 'yt/models/claimed_video_defaults_set'

describe Yt::ClaimedVideoDefaultsSet do
  subject(:claimed_video_defaults) { Yt::ClaimedVideoDefaultsSet.new data: data }

  describe '#channel_override' do
    let(:data) { {"channelOverride"=>true} }
    it{ expect(claimed_video_defaults.channel_override).to be(true) }
  end

  describe '#new_video_defaults' do
    let(:data) { {"newVideoDefaults"=> ["long", "overlay"]} }
    it{ expect(claimed_video_defaults.new_video_defaults).to match_array ["long", "overlay"] }
  end
end
