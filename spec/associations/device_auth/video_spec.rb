require 'spec_helper'
require 'yt/models/video'

describe Yt::Video, :device_app do
  subject(:video) { Yt::Video.new id: id, auth: $account }

  context 'given an existing video' do
    let(:id) { 'MESycYJytkU' }

    it { expect(video.content_detail).to be_a Yt::ContentDetail }
    it { expect(video.snippet).to be_a Yt::Snippet }
    it { expect(video.rating).to be_a Yt::Rating }
    it { expect(video.status).to be_a Yt::Status }
    it { expect(video.statistics_set).to be_a Yt::StatisticsSet }

    context 'that I like' do
      before { video.like }
      it { expect(video).to be_liked }
      it { expect(video.dislike).to be true }
    end

    context 'that I dislike' do
      before { video.dislike }
      it { expect(video).not_to be_liked }
      it { expect(video.like).to be true }
    end

    context 'that I am indifferent to' do
      before { video.unlike }
      it { expect(video).not_to be_liked }
      it { expect(video.like).to be true }
    end
  end

  context 'given an unknown video' do
    let(:id) { 'not-a-video-id' }

    it { expect{video.content_detail}.to raise_error Yt::Errors::NoItems }
    it { expect{video.snippet}.to raise_error Yt::Errors::NoItems }
    it { expect{video.rating}.to raise_error Yt::Errors::NoItems }
    it { expect{video.status}.to raise_error Yt::Errors::NoItems }
    it { expect{video.statistics_set}.to raise_error Yt::Errors::NoItems }
  end
end