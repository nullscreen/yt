require 'spec_helper'
require 'yt/models/resource'

describe Yt::Resource do
  subject(:resource) { Yt::Resource.new attrs }

  context 'given a resource initialized with a URL (containing an ID)' do
    let(:attrs) { {url: 'youtu.be/MESycYJytkU'} }

    it { expect(resource.id).to eq 'MESycYJytkU' }
    it { expect(resource.kind).to eq 'video' }
    it { expect(resource.username).to be_nil }
  end

  context 'given a resource initialized with a URL (containing a username)' do
    let(:attrs) { {url: 'youtube.com/fullscreen'} }

    it { expect(resource.kind).to eq 'channel' }
    it { expect(resource.username).to eq 'fullscreen' }
  end
end