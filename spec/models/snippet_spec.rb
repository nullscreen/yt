require 'spec_helper'
require 'yt/models/snippet'

describe Yt::Snippet do
  subject(:snippet) { Yt::Snippet.new data: data }
  let(:data) { {} }

  describe '#data' do
    let(:data) { {"key"=>"value"} }
    specify 'returns the data the snippet was initialized with' do
      expect(snippet.data).to eq data
    end
  end

  describe '#title' do
    context 'given a snippet with a title' do
      let(:data) { {"title"=>"Fullscreen"} }
      it { expect(snippet.title).to eq 'Fullscreen' }
    end

    context 'given a snippet without a title' do
      it { expect(snippet.title).to eq '' }
    end
  end

  describe '#published_at' do
    context 'given a snippet with a timestamp' do # always returned by YouTube
      let(:data) { {"publishedAt"=>"2014-04-22T19:14:49.000Z"} }
      it { expect(snippet.published_at.year).to be 2014 }
    end
  end

  describe '#description' do
    context 'given a snippet with a description' do
      let(:data) { {"description"=>"The first media company for the connected generation."} }
      it { expect(snippet.description).to eq 'The first media company for the connected generation.' }
    end

    context 'given a snippet without a description' do
      it { expect(snippet.description).to eq '' }
    end
  end

  describe '#tags' do
    context 'given a snippet with tags' do
      let(:data) { {"tags"=>["promotion", "new media"]} }
      it { expect(snippet.tags).to eq ["promotion", "new media"] }
    end

    context 'given a snippet without tags' do
      it { expect(snippet.tags).to eq [] }
    end
  end

  describe '#thumbnail_url' do
    context 'given a snippet with thumbnails' do
      let(:data) { {"thumbnails"=>{
        "default"=>{"url"=> "http://example.com/88x88.jpg"},
        "medium"=>{"url"=> "http://example.com/240x240.jpg"},
      }} }
      it { expect(snippet.thumbnail_url).to eq 'http://example.com/88x88.jpg' }
      it { expect(snippet.thumbnail_url 'default').to eq 'http://example.com/88x88.jpg' }
      it { expect(snippet.thumbnail_url :default).to eq 'http://example.com/88x88.jpg' }
      it { expect(snippet.thumbnail_url :medium).to eq 'http://example.com/240x240.jpg' }
      it { expect(snippet.thumbnail_url :large).to be_nil }
    end

    context 'given a snippet without thumbnails' do
      it { expect(snippet.thumbnail_url).to be_nil }
    end
  end

  describe '#channel_id' do
    context 'given a snippet with a channel ID' do
      let(:data) { {"channelId"=>"UCxO1tY8h1AhOz0T4ENwmpow"} }
      it { expect(snippet.channel_id).to eq 'UCxO1tY8h1AhOz0T4ENwmpow' }
    end

    context 'given a snippet without a channel ID' do
      it { expect(snippet.channel_id).to be_nil }
    end
  end

  describe '#channel_title' do
    context 'given a snippet with a channel title' do
      let(:data) { {"channelTitle"=>"Fullscreen"} }
      it { expect(snippet.channel_title).to eq 'Fullscreen' }
    end

    context 'given a snippet without a channel title' do
      it { expect(snippet.channel_title).to be_nil }
    end
  end

  describe '#category_id' do
    context 'given a snippet with a category ID' do
      let(:data) { {"categoryId"=>"22"} }
      it { expect(snippet.category_id).to eq '22' }
    end

    context 'given a snippet without a category ID' do
      it { expect(snippet.category_id).to be_nil }
    end
  end

  describe '#live_broadcast_content' do
    context 'given a snippet with live broadcast content' do
      let(:data) { {"liveBroadcastContent"=>"live"} }
      it { expect(snippet.live_broadcast_content).to eq 'live' }
    end

    context 'given a snippet without live broadcast content' do
      it { expect(snippet.live_broadcast_content).to be_nil }
    end
  end

  describe '#video_id and #video' do
    context 'given a snippet with a video resource' do
      let(:data) { {"resourceId"=>{"kind"=>"youtube#video","videoId"=>"W4GhTprSsOY"}} }
      it { expect(snippet.video_id).to eq 'W4GhTprSsOY' }
      it { expect(snippet.video).to be_a Yt::Models::Video }
      it { expect(snippet.video.id).to eq 'W4GhTprSsOY' }
    end

    context 'given a snippet without a video resource' do
      it { expect(snippet.video_id).to be_nil }
      it { expect(snippet.video).to be_nil }
    end
  end
end