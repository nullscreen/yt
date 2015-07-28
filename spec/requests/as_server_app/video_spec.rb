require 'spec_helper'
require 'yt/models/video'

describe Yt::Video, :server_app do
  subject(:video) { Yt::Video.new attrs }

  context 'given an existing video ID' do
    let(:attrs) { {id: 'MESycYJytkU'} }

    it { expect(video.content_detail).to be_a Yt::ContentDetail }

    it 'returns valid snippet data' do
      expect(video.snippet).to be_a Yt::Snippet
      expect(video.title).to be_a String
      expect(video.description).to be_a Yt::Description
      expect(video.thumbnail_url).to be_a String
      expect(video.published_at).to be_a Time
      expect(video.tags).to be_an Array
      expect(video.channel_id).to be_a String
      expect(video.channel_title).to be_a String
      expect(video.category_id).to be_a String
      expect(video.live_broadcast_content).to be_a String
    end

    it { expect(video.status).to be_a Yt::Status }
    it { expect(video.statistics_set).to be_a Yt::StatisticsSet }
  end

  context 'given an existing video URL' do
    let(:attrs) { {url: 'https://www.youtube.com/watch?v=MESycYJytkU&list=LLxO1tY8h1AhOz0T4ENwmpow'} }

    specify 'provides access to its data' do
      expect(video.id).to eq 'MESycYJytkU'
      expect(video.title).to eq 'Fullscreen Creator Platform'
      expect(video.privacy_status).to eq 'public'
    end
  end

  context 'given an unknown video ID' do
    let(:attrs) { {id: 'not-a-video-id'} }

    it { expect{video.content_detail}.to raise_error Yt::Errors::NoItems }
    it { expect{video.snippet}.to raise_error Yt::Errors::NoItems }
    it { expect{video.status}.to raise_error Yt::Errors::NoItems }
    it { expect{video.statistics_set}.to raise_error Yt::Errors::NoItems }
  end

  context 'given an unknown video URL' do
    let(:attrs) { {url: 'youtube.com/--not-a-valid-url--'} }

    specify 'accessing its data raises an error' do
      expect{video.id}.to raise_error Yt::Errors::NoItems
      expect{video.title}.to raise_error Yt::Errors::NoItems
      expect{video.status}.to raise_error Yt::Errors::NoItems
    end
  end

end