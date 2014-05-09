require 'spec_helper'
require 'yt/associations/annotations'
require 'yt/models/video'

describe Yt::Associations::Annotations do
  subject(:annotations) { video.annotations }

  describe '#annotations' do
    context 'given an existing video with annotations' do
      let(:video) { Yt::Video.new id: 'MESycYJytkU' }
      it { expect(annotations.count).to be > 0 }
      it { expect(annotations.first).to be_a Yt::Annotation }
    end
  end
end