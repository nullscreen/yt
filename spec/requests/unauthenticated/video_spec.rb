require 'spec_helper'
require 'yt/models/video'

describe Yt::Video, :vcr do
  subject(:video) { Yt::Video.new id: id }

  context 'given a public video with annotations' do
    let(:id) { '9bZkp7q19f0' }

    it { expect(video.annotations).to be_a Yt::Collections::Annotations }
    it { expect(video.annotations.first).to be_a Yt::Annotation }
    it { expect(video.annotations.size).to be > 0 }
  end
end
