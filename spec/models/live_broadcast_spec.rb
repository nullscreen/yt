require 'spec_helper'
require 'yt/models/live_broadcast'

describe Yt::LiveBroadcast do
  subject(:broadcast) { Yt::LiveBroadcast.new attrs }


  describe '#title' do
    context 'given a snippet with a title' do
      let(:attrs) { {snippet: {"title"=>"Fullscreen"}} }
      it { expect(broadcast.title).to eq 'Fullscreen' }
    end

    context 'given a snippet without a title' do
      let(:attrs) { {snippet: {}} }
      it { expect(broadcast.title).to eq '' }
    end
  end

  describe '#published_at' do
    context 'given a snippet with a timestamp' do # always returned by YouTube
      let(:attrs) { {snippet: {"publishedAt"=>"2014-04-22T19:14:49.000Z"}} }
      it { expect(broadcast.published_at.year).to be 2014 }
    end
  end

  describe '#description' do
    context 'given a snippet with a description' do
      let(:attrs) { {snippet: {"description"=>"The first media company for the connected generation."}} }
      it { expect(broadcast.description).to eq 'The first media company for the connected generation.' }
    end

    context 'given a snippet without a description' do
      let(:attrs) { {snippet: {}} }
      it { expect(broadcast.description).to eq '' }
    end
  end

  describe '#exists?' do
    context 'given a broadcast with an id' do
      let(:attrs) { {id: 'PLSWYkYzOr'} }
      it { expect(broadcast).to exist }
    end

    context 'given a broadcast without an id' do
      let(:attrs) { {} }
      it { expect(broadcast).not_to exist }
    end
  end

  describe '#snippet' do
    context 'given fetching a broadcast returns a snippet' do
      let(:attrs) { {snippet: {"title"=>"Fullscreen"}} }
      it { expect(broadcast.snippet).to be_a Yt::Snippet }
    end
  end

  describe '#status' do
    context 'given fetching a broadcast returns a status' do
      let(:attrs) { {status: {"privacyStatus"=>"public"}} }
      it { expect(broadcast.status).to be_a Yt::Status }
    end
  end

  describe '#update' do
    let(:attrs) { {id: 'PLSWYkYzOr', snippet: {'title'=>'old'}, status: {"privacyStatus"=>"public"}} }
    before { expect(broadcast).to receive(:do_update).and_yield 'snippet'=>{'title'=>'new'} }

    it { expect(broadcast.update title: 'new').to be true }
    it { expect{broadcast.update title: 'new'}.to change{broadcast.title} }
  end

  describe '#delete' do
    let(:attrs) { {id: 'PLSWYkYzOr'} }

    context 'given an existing broadcast' do
      before { expect(broadcast).to receive(:do_delete).and_yield }

      it { expect(broadcast.delete).to be true }
      it { expect{broadcast.delete}.to change{broadcast.exists?} }
    end
  end
end
