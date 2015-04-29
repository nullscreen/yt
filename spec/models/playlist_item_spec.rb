require 'spec_helper'
require 'yt/models/playlist_item'

describe Yt::PlaylistItem do
  subject(:item) { Yt::PlaylistItem.new attrs }

  describe '#title' do
    context 'given a snippet with a title' do
      let(:attrs) { {snippet: {"title"=>"Fullscreen"}} }
      it { expect(item.title).to eq 'Fullscreen' }
    end

    context 'given a snippet without a title' do
      let(:attrs) { {snippet: {}} }
      it { expect(item.title).to eq '' }
    end
  end

  describe '#published_at' do
    context 'given a snippet with a timestamp' do
      let(:attrs) { {snippet: {"publishedAt"=>"2014-04-22T19:14:49.000Z"}} }
      it { expect(item.published_at.year).to be 2014 }
    end
  end

  describe '#description' do
    context 'given a snippet with a description' do
      let(:attrs) { {snippet: {"description"=>"A video."}} }
      it { expect(item.description).to eq 'A video.' }
    end

    context 'given a snippet without a description' do
      let(:attrs) { {snippet: {}} }
      it { expect(item.description).to eq '' }
    end
  end

  describe '#thumbnail_url' do
    context 'given a snippet with thumbnails' do
      let(:attrs) { {snippet: {"thumbnails"=>{
        "default"=>{"url"=> "http://example.com/120x90.jpg"},
        "medium"=>{"url"=> "http://example.com/320x180.jpg"},
      }}} }
      it { expect(item.thumbnail_url).to eq 'http://example.com/120x90.jpg' }
      it { expect(item.thumbnail_url 'default').to eq 'http://example.com/120x90.jpg' }
      it { expect(item.thumbnail_url :default).to eq 'http://example.com/120x90.jpg' }
      it { expect(item.thumbnail_url :medium).to eq 'http://example.com/320x180.jpg' }
      it { expect(item.thumbnail_url :large).to be_nil }
    end

    context 'given a snippet without thumbnails' do
      let(:attrs) { {snippet: {}} }
      it { expect(item.thumbnail_url).to be_nil }
    end
  end

  describe '#channel_id' do
    context 'given a snippet with a channel ID' do
      let(:attrs) { {snippet: {"channelId"=>"UCxO1tY8h1AhOz0T4ENwmpow"}} }
      it { expect(item.channel_id).to eq 'UCxO1tY8h1AhOz0T4ENwmpow' }
    end

    context 'given a snippet without a channel ID' do
      let(:attrs) { {snippet: {}} }
      it { expect(item.channel_id).to be_nil }
    end
  end

  describe '#channel_title' do
    context 'given a snippet with a channel title' do
      let(:attrs) { {snippet: {"channelTitle"=>"Fullscreen"}} }
      it { expect(item.channel_title).to eq 'Fullscreen' }
    end

    context 'given a snippet without a channel title' do
      let(:attrs) { {snippet: {}} }
      it { expect(item.channel_title).to be_nil }
    end
  end

  describe '#video_id and #video' do
    context 'given a snippet with a video resource' do
      let(:attrs) { {snippet: {"resourceId"=>{"kind"=>"youtube#video","videoId"=>"W4GhTprSsOY"}}} }
      it { expect(item.video_id).to eq 'W4GhTprSsOY' }
      it { expect(item.video).to be_a Yt::Models::Video }
      it { expect(item.video.id).to eq 'W4GhTprSsOY' }
    end

    context 'given a snippet without a video resource' do
      let(:attrs) { {snippet: {}} }
      it { expect(item.video_id).to be_nil }
      it { expect(item.video).to be_nil }
    end
  end

  describe '#snippet' do
    context 'given fetching a playlist item returns a snippet' do
      let(:attrs) { {snippet: {"position"=>0}} }
      it { expect(item.snippet).to be_a Yt::Snippet }
    end
  end

  describe '#status' do
    context 'given fetching a playlist item returns a status' do
      let(:attrs) { {status: {"privacyStatus"=>"public"}} }
      it { expect(item.status).to be_a Yt::Status }
    end
  end

  describe '#delete' do
    let(:attrs) { {id: 'playlist-item-id'} }

    context 'given an existing playlist item' do
      before { expect(item).to receive(:do_delete).and_yield }

      it { expect(item.delete).to be true }
      it { expect{item.delete}.to change{item.exists?} }
    end
  end
end