require 'spec_helper'
require 'yt/models/video_category'

describe Yt::VideoCategory do
  subject(:video_category) { Yt::VideoCategory.new attrs }

  describe '#id' do
    context 'given fetching a video category returns an id' do
      let(:attrs) { {id: "22"} }
      it { expect(video_category.id).to eq '22' }
    end
  end

  describe '#snippet' do
    context 'given fetching a video category returns a snippet' do
      let(:attrs) { {snippet: {"title": "People & Blogs", "assignable": true}} }

      it { expect(video_category.snippet).to be_a Yt::Snippet }
    end
  end
end