require 'spec_helper'
require 'yt/models/video'

describe Yt::Video, :device_app do
  subject(:video) { Yt::Video.new id: id, auth: $account }

  context 'given a public video with annotations' do
    let(:id) { 'MESycYJytkU' }

    it { expect(video.annotations).to be_a Yt::Collections::Annotations }
    it { expect(video.annotations.first).to be_a Yt::Annotation }
  end

  context 'given a private video' do
    let(:id) { 'JzDEc54FVTc' }

    it { expect(video.annotations).to be_a Yt::Collections::Annotations }
    it { expect(video.annotations.count).to be_zero }
  end
end