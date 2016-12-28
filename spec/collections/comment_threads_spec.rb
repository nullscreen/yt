require 'spec_helper'
require 'yt/collections/comment_threads'
require 'yt/models/video'
require 'yt/models/channel'

describe Yt::Collections::CommentThreads do
  subject(:collection) { Yt::Collections::CommentThreads.new parent: parent}

  describe '#size', :ruby2 do
    describe 'sends only one request and return the total results' do
      let(:total_results) { 1234 }
      let(:parent) { Yt::Video.new id: 'any-id' }

      before do
        expect_any_instance_of(Yt::Request).to receive(:run).once do
          double(body: {'pageInfo'=>{'totalResults'=>total_results}})
        end
      end
      it { expect(collection.size).to be total_results }
    end
  end

  describe '#count' do
    let(:query) { {q: 'search string'} }
    let(:parent) { Yt::Video.new id: 'any-id' }
    let(:page) { {items: [], token: 'any-token'} }

    context 'called once with .where(query) and once without' do
      after do
        collection.where(query).count
        collection.count
      end

      it 'only applies the query on the first call' do
        expect(collection).to receive(:fetch_page) do |options|
          expect(options[:params]).to include query
          page
        end
        expect(collection).to receive(:fetch_page) do |options|
          expect(options[:params]).not_to include query
          page
        end
      end
    end
  end
end
