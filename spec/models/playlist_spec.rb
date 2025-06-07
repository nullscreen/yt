require 'spec_helper'
require 'yt/models/playlist'

describe Yt::Playlist do
  subject(:playlist) { Yt::Playlist.new attrs }

  describe '#etag' do
    context 'given the API response includes an etag' do
      let(:attrs) { {id: 'any-id', etag: 'etag123'} }
      it { expect(playlist.etag).to eq 'etag123' }
    end

    context 'given only an ID is provided' do
      let(:attrs) { {id: 'any-id', auth: double('auth')} }
      let(:etag) { 'etag123' }

      before do
        expect_any_instance_of(Yt::Request).to receive(:run).once do
          double(body: {'etag' => etag, 'items'=> [{'id'=> 'any-id', 'etag'=> etag}], 'pageInfo'=> {'totalResults'=> 1}})
        end
      end

      it 'fetches the etag from YouTube' do
        expect(playlist.etag).to eq etag
      end
    end

    context 'given an ID is provided but no auth' do
      let(:attrs) { {id: 'any-id'} }

      it 'returns the etag from the API response even if no items are found' do
        expect_any_instance_of(Yt::Request).to receive(:run).once do
          double(body: {'etag' => 'mockedEtag', 'items'=> [], 'pageInfo'=> {'totalResults'=> 0}})
        end
        expect(playlist.etag).to eq 'mockedEtag'
      end
    end

    context 'given no ID is provided' do
      let(:attrs) { {} }

      it 'returns nil' do
        expect_any_instance_of(Yt::Request).not_to receive(:run)
        expect(playlist.etag).to be_nil
      end
    end
  end

  describe '#title' do
    context 'given a snippet with a title' do
      let(:attrs) { {snippet: {"title"=>"Fullscreen"}} }
      it { expect(playlist.title).to eq 'Fullscreen' }
    end

    context 'given a snippet without a title' do
      let(:attrs) { {snippet: {}} }
      it { expect(playlist.title).to eq '' }
    end
  end

  describe '#published_at' do
    context 'given a snippet with a timestamp' do # always returned by YouTube
      let(:attrs) { {snippet: {"publishedAt"=>"2014-04-22T19:14:49.000Z"}} }
      it { expect(playlist.published_at.year).to be 2014 }
    end
  end

  describe '#description' do
    context 'given a snippet with a description' do
      let(:attrs) { {snippet: {"description"=>"The first media company for the connected generation."}} }
      it { expect(playlist.description).to eq 'The first media company for the connected generation.' }
    end

    context 'given a snippet without a description' do
      let(:attrs) { {snippet: {}} }
      it { expect(playlist.description).to eq '' }
    end
  end

  describe '#thumbnail_url' do
    context 'given a snippet with thumbnails' do
      let(:attrs) { {snippet: {"thumbnails"=>{
        "default"=>{"url"=> "http://example.com/88x88.jpg"},
        "medium"=>{"url"=> "http://example.com/240x240.jpg"},
      }}} }
      it { expect(playlist.thumbnail_url).to eq 'http://example.com/88x88.jpg' }
      it { expect(playlist.thumbnail_url 'default').to eq 'http://example.com/88x88.jpg' }
      it { expect(playlist.thumbnail_url :default).to eq 'http://example.com/88x88.jpg' }
      it { expect(playlist.thumbnail_url :medium).to eq 'http://example.com/240x240.jpg' }
      it { expect(playlist.thumbnail_url :large).to be_nil }
    end

    context 'given a snippet without thumbnails' do
      let(:attrs) { {snippet: {}} }
      it { expect(playlist.thumbnail_url).to be_nil }
    end
  end

  describe '#channel_id' do
    context 'given a snippet with a channel ID' do
      let(:attrs) { {snippet: {"channelId"=>"UCxO1tY8h1AhOz0T4ENwmpow"}} }
      it { expect(playlist.channel_id).to eq 'UCxO1tY8h1AhOz0T4ENwmpow' }
    end

    context 'given a snippet without a channel ID' do
      let(:attrs) { {snippet: {}} }
      it { expect(playlist.channel_id).to be_nil }
    end
  end

  describe '#channel_title' do
    context 'given a snippet with a channel title' do
      let(:attrs) { {snippet: {"channelTitle"=>"Fullscreen"}} }
      it { expect(playlist.channel_title).to eq 'Fullscreen' }
    end

    context 'given a snippet without a channel title' do
      let(:attrs) { {snippet: {}} }
      it { expect(playlist.channel_title).to be_nil }
    end
  end

  describe '#exists?' do
    context 'given a playlist with an id' do
      let(:attrs) { {id: 'PLSWYkYzOr'} }
      it { expect(playlist).to exist }
    end

    context 'given a playlist without an id' do
      let(:attrs) { {} }
      it { expect(playlist).not_to exist }
    end
  end

  describe '#snippet' do
    context 'given fetching a playlist returns a snippet' do
      let(:attrs) { {snippet: {"title"=>"Fullscreen"}} }
      it { expect(playlist.snippet).to be_a Yt::Snippet }
    end
  end

  describe '#status' do
    context 'given fetching a playlist returns a status' do
      let(:attrs) { {status: {"privacyStatus"=>"public"}} }
      it { expect(playlist.status).to be_a Yt::Status }
    end
  end

  describe '#update' do
    let(:attrs) { {id: 'PLSWYkYzOr', snippet: {'title'=>'old'}, status: {"privacyStatus"=>"public"}} }
    before { expect(playlist).to receive(:do_update).and_yield 'snippet'=>{'title'=>'new'} }

    it { expect(playlist.update title: 'new').to be true }
    it { expect{playlist.update title: 'new'}.to change{playlist.title} }
  end

  describe '#delete' do
    let(:attrs) { {id: 'PLSWYkYzOr'} }

    context 'given an existing playlist' do
      before { expect(playlist).to receive(:do_delete).and_yield }

      it { expect(playlist.delete).to be true }
      it { expect{playlist.delete}.to change{playlist.exists?} }
    end
  end
end
