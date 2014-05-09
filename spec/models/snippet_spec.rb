require 'spec_helper'
require 'yt/models/snippet'

describe Yt::Snippet do
  subject(:snippet) { Yt::Snippet.new data: data }

  describe '#title' do
    context 'given fetching a snippet returns a title' do
      let(:data) { {"title"=>"Fullscreen"} }
      it { expect(snippet.title).to eq 'Fullscreen' }
    end

    context 'given fetching a snippet does not return a title' do
      let(:data) { {"description"=>"The first media company for the connected generation."} }
      it { expect(snippet.title).to eq '' }
    end
  end

  describe '#published_at' do # publishedAt is always returned by YouTube
    let(:data) { {"publishedAt"=>"2014-04-22T19:14:49.000Z"} }
    it { expect(snippet.published_at.year).to be 2014 }
  end

  describe '#description' do
    context 'given fetching a snippet returns a description' do
      let(:data) { {"description"=>"The first media company for the connected generation."} }
      it { expect(snippet.description).to eq 'The first media company for the connected generation.' }
    end

    context 'given fetching a snippet does not return a description' do
      let(:data) { {"title"=>"Fullscreen"} }
      it { expect(snippet.description).to eq '' }
    end
  end

  describe '#tags' do
    context 'given fetching a snippet returns some tags' do
      let(:data) { {"tags"=>["promotion", "new media"]} }
      it { expect(snippet.tags).to eq ["promotion", "new media"] }
    end

    context 'given fetching a snippet does not return any tag' do
      let(:data) { {"title"=>"Fullscreen"} }
      it { expect(snippet.tags).to eq [] }
    end
  end

  describe '#thumbnail_url' do
    context 'given fetching a snippet returns some thumbnails' do
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

    context 'given fetching a snippet returns any thumbnail' do
      let(:data) { {"title"=>"Fullscreen"} }
      it { expect(snippet.thumbnail_url).to be_nil }
    end
  end
end