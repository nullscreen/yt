# encoding: UTF-8

require 'spec_helper'
require 'yt/models/video'

describe Yt::Video, :device_app do
  subject(:video) { Yt::Video.new id: id, auth: $account }

  context 'given someone else’s video' do
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

    it { expect(video.rating).to be_a Yt::Rating }
    it { expect(video.status).to be_a Yt::Status }
    it { expect(video.statistics_set).to be_a Yt::StatisticsSet }
    it { expect{video.update}.to fail }

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

  context 'given one of my own videos that I want to update' do
    let(:id) { $account.videos.first.id }

    describe 'updates the attributes that I specify explicitly' do
      # NOTE: The use of UTF-8 characters is to test that we can pass up to
      # 50 characters, independently of their representation
      let(:attrs) { {title: "Yt Example Update Video #{rand} - ®•♡❥❦❧☙"} }
      it { expect(video.update attrs).to eq true }
      it { expect{video.update attrs}.to change{video.title} }
    end

    describe 'does not update the other attributes' do
      let(:attrs) { {} }
      it { expect(video.update attrs).to eq true }
      it { expect{video.update attrs}.not_to change{video.title} }
      it { expect{video.update attrs}.not_to change{video.description} }
      it { expect{video.update attrs}.not_to change{video.tags} }
      it { expect{video.update attrs}.not_to change{video.category_id} }
      it { expect{video.update attrs}.not_to change{video.privacy_status} }
    end
  end
end