require 'spec_helper'
require 'yt/models/video'

describe Yt::Video, :device_app do
  subject(:video) { Yt::Video.new id: id, auth: $account }

  context 'given an existing video with annotations' do
    let(:id) { 'MESycYJytkU' }

    it { expect(video.annotations).to be_a Yt::Collections::Annotations }
    it { expect(video.annotations.first).to be_a Yt::Annotation }
  end
end