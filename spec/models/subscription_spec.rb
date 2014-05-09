require 'spec_helper'
require 'yt/models/subscription'

describe Yt::Subscription do
  subject(:subscription) { Yt::Subscription.new id: id }

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
      let(:msg) { '{"error"=>{"errors"=>[{"reason"=>"subscriptionNotFound"}]}}' }
      before { subscription.stub(:do_delete).and_raise Yt::RequestError, msg }

      it { expect{subscription.delete}.to raise_error Yt::RequestError, msg }
      it { expect{subscription.delete ignore_not_found: true}.not_to raise_error }
    end
  end
end