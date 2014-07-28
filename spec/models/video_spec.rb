require 'spec_helper'
require 'yt/models/video'

describe Yt::Video do
  subject(:video) { Yt::Video.new attrs }

  describe '#snippet' do
    context 'given fetching a video returns a snippet' do
      let(:attrs) { {snippet: {"title"=>"Fullscreen Creator Platform"}} }
      it { expect(video.snippet).to be_a Yt::Snippet }
    end
  end

  describe '#update' do
    let(:attrs) { {id: 'MESycYJytkU', snippet: {'title'=>'old'}} }
    before { expect(video).to receive(:do_update).and_yield 'snippet'=>{'title'=>'new'} }

    it { expect(video.update title: 'new').to be true }
    it { expect{video.update title: 'new'}.to change{video.title} }
  end

  describe '#delete' do
    let(:attrs) { {id: 'video-id'} }

    context 'given an existing video' do
      before { expect(video).to receive(:do_delete).and_yield }

      it { expect(video.delete).to be true }
      it { expect{video.delete}.to change{video.exists?} }
    end
  end
end