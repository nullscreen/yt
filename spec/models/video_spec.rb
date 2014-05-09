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
end