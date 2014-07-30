require 'spec_helper'
require 'yt/collections/references'
require 'yt/models/content_owner'

describe Yt::Collections::References do
  subject(:collection) { Yt::Collections::References.new parent: content_owner }
  let(:content_owner) { Yt::ContentOwner.new id: 'any-id' }
  let(:page) { {items: [], token: 'any-token'} }
  let(:query) { {id: 'reference-id'} }

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