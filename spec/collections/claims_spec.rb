require 'spec_helper'
require 'yt/collections/claims'
require 'yt/models/content_owner'

describe Yt::Collections::Claims do
  let(:content_owner) { Yt::ContentOwner.new owner_name: 'any-name' }
  let(:page) { {items: [], token: 'any-token'} }

  describe '#count' do
    context 'called once with .where(query) and once without, for claims with its parent' do
      let(:collection) { Yt::Collections::Claims.new parent: content_owner }
      let(:query) { {q: 'search string'} }

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

    context 'called once with .where(query) and once without, for claims without its parent' do
      let(:collection_no_parent) { Yt::Collections::Claims.new auth: content_owner}
      let(:query) { {video_id: "video-ids"} }

      after do
        collection_no_parent.where(query).count
        collection_no_parent.count
      end

      it 'only applies the query on the first call' do
        expect(collection_no_parent).to receive(:fetch_page) do |options|
          expect(options[:params]).to include query
          page
        end
        expect(collection_no_parent).to receive(:fetch_page) do |options|
          expect(options[:params]).not_to include query
          page
        end
      end
    end
  end
end
