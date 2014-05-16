require 'spec_helper'
require 'yt/collections/subscriptions'

describe Yt::Collections::Subscriptions do
  subject(:collection) { Yt::Collections::Subscriptions.new }
  before { collection.stub :throttle }
  let(:response_body) { %Q{{"error":{"errors":[{"reason":"#{reason}"}]}}} }
  let(:msg) { {response: {body: response_body}}.to_json }

  describe '#insert' do
    context 'given a new subscription' do
      let(:subscription) { Yt::Subscription.new }
      before { collection.stub(:do_insert).and_return subscription }

      it { expect(collection.insert).to eq subscription }
    end

    context 'given a duplicate subscription' do
      let(:reason) { 'subscriptionDuplicate' }
      before { collection.stub(:do_insert).and_raise Yt::Errors::Failed, msg }

      it { expect{collection.insert}.to fail.with 'subscriptionDuplicate' }
      it { expect{collection.insert ignore_errors: true}.not_to fail }
    end
  end

  describe '#delete_all' do
    before { collection.stub(:do_delete_all).and_return [true] }

    it { expect(collection.delete_all).to eq [true] }
  end
end