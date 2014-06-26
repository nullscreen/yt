require 'spec_helper'
require 'yt/models/video'

describe Yt::Video, :server_app do
  subject(:video) { Yt::Video.new id: id }

  context 'given an existing video' do
    let(:id) { 'MESycYJytkU' }

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

  context 'given an unknown video' do
    let(:id) { 'not-a-video-id' }

    it { expect{video.content_detail}.to raise_error Yt::Errors::NoItems }
    it { expect{video.snippet}.to raise_error Yt::Errors::NoItems }
    it { expect{video.status}.to raise_error Yt::Errors::NoItems }
    it { expect{video.statistics_set}.to raise_error Yt::Errors::NoItems }
  end
end