require 'spec_helper'
require 'yt/models/subscription'

describe Yt::Subscription do
  subject(:subscription) { Yt::Subscription.new id: id }
  let(:response_body) { %Q{{"error":{"errors":[{"reason":"#{reason}"}]}}} }
  let(:msg) { {response: {body: response_body}}.to_json }

  describe '#exists?' do
    context 'given a subscription with an id' do
      let(:id) { 'CBl6OoF0BpiV' }
      it { expect(subscription).to exist }
    end

    context 'given a subscription without an id' do
      let(:id) { nil }
      it { expect(subscription).not_to exist }
    end
  end

  describe '#delete' do
    let(:id) { 'CBl6OoF0BpiV' }

    context 'given an existing subscription' do
      before { subscription.stub(:do_delete).and_yield }

      it { expect(subscription.delete).to be_true }
      it { expect{subscription.delete}.to change{subscription.exists?} }
    end

    context 'given an unknown subscription' do
      let(:reason) { 'subscriptionNotFound' }
      before { subscription.stub(:do_delete).and_raise Yt::Errors::Failed, msg }

      it { expect{subscription.delete}.to fail.with 'subscriptionNotFound' }
      it { expect{subscription.delete ignore_errors: true}.not_to fail }
    end
  end
end