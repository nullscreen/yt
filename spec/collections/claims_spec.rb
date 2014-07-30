require 'spec_helper'
require 'yt/collections/claims'
require 'yt/models/content_owner'

describe Yt::Collections::Claims do
  subject(:collection) { Yt::Collections::Claims.new parent: content_owner }
  let(:content_owner) { Yt::ContentOwner.new owner_name: 'any-name' }
  let(:page) { {items: [], token: 'any-token'} }
  let(:query) { {q: 'search string'} }

  describe '#count' do
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