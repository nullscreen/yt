require 'spec_helper'
require 'yt/collections/claims'
require 'yt/models/content_owner'

describe Yt::Collections::Claims do
  let(:content_owner) { Yt::ContentOwner.new owner_name: 'any-name' }
  let(:collection) { Yt::Collections::Claims.new parent: content_owner, auth: content_owner }
  let(:page) { {items: [], token: 'any-token'} }
  let(:query) { {q: 'search string'} }

  describe "#insert" do
    let(:attributes) {
      {
        asset_id: 'some_asset_id',
        video_id: 'some_video_id',
        content_type: 'audiovisual',
        policy: { id: 'some_policy_id' },
        match_info: { match_segments: [ { manual_segment: { start: "00:01:00.000", finish: "00:02:00.000" } } ] },
        is_manual_claim: true
      }
    }

    before do
      allow(collection).to receive(:do_insert)
      collection.insert(attributes.deep_dup)
    end

    it 'calls do_insert with appropriate body' do
      body = {
        asset_id: 'some_asset_id',
        video_id: 'some_video_id',
        content_type: 'audiovisual',
        policy: { id: 'some_policy_id' },
        match_info: { matchSegments: [ { manual_segment: { start: "00:01:00.000", finish: "00:02:00.000" } } ] }
      }
      expect(collection).to have_received(:do_insert).with(
        params: { is_manual_claim: true, on_behalf_of_content_owner: content_owner.owner_name },
        body: body
      )
    end
  end

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
