require 'spec_helper'
require 'yt/collections/subscriptions'

describe Yt::Collections::Subscriptions do
  subject(:collection) { Yt::Collections::Subscriptions.new parent: Yt::Channel.new(id: 'any-id') }
  let(:msg) { {response_body: {error: {errors: [{reason: reason}]}}}.to_json }
  before { expect(collection).to behave }

  describe '#insert' do
    context 'given a new subscription' do
      let(:subscription) { Yt::Subscription.new }
      let(:behave) { receive(:do_insert).and_return subscription }

      it { expect(collection.insert).to eq subscription }
    end

    context 'given a duplicate subscription' do
      let(:reason) { 'subscriptionDuplicate' }
      let(:behave) { receive(:do_insert).and_raise Yt::Error, msg }

      it { expect{collection.insert}.to fail.with 'subscriptionDuplicate' }
      it { expect{collection.insert ignore_errors: true}.not_to fail }
    end
  end

  describe '#etag' do
    let(:etag) { 'etag123' }
    let(:behave) { receive(:fetch_etag).and_call_original }

    before do
      expect_any_instance_of(Yt::Request).to receive(:run).once do
        double(body: {'etag'=> etag, 'items'=> [], 'pageInfo'=> {'totalResults'=>0}})
      end
    end

    it 'returns the etag from the list response' do
      expect(collection.etag).to eq etag
    end
  end
end
