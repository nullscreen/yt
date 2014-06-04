require 'spec_helper'
require 'yt/collections/earnings'

describe Yt::Collections::Earnings do
  subject(:collection) { Yt::Collections::Earnings.new parent: channel }
  let(:channel) { Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow' }
  let(:msg) { {response_body: {error: {errors: [error]}}}.to_json }
  let(:date) { 1.day.ago.to_date }
  let(:dollars) { 10 }
  let(:message) { 'Invalid query. Query did not conform to the expectations.' }
  before { expect(collection).to behave }

  describe '#within' do
    context 'given YouTube responds with a list of earnings' do
      let(:behave) { receive(:flat_map).and_return [date, dollars] }

      it { expect(collection.within(date..date)[date]).to eq dollars }
    end

    # NOTE: This test is just a reflection of YouTube irrational behavior
    # of raising 400 or 504 error once in a while when retrieving earnings.
    # Hopefully this will get fixed and this code (and test) removed.
    context 'given YouTube responds to the first request with' do
      let(:behave) { receive(:flat_map) do
        expect(collection).to receive(:flat_map).and_return [date, dollars]
        raise Yt::Error, msg
      end}

      context 'an Invalid Query error' do
        let(:error) { {reason: 'badRequest', message: message} }

        it { expect(collection.within(date..date)[date]).to eq dollars }
      end

      context 'a Backend error' do
        let(:error) { {reason: 'backendError', message: 'Backend Error'} }

        it { expect(collection.within(date..date)[date]).to eq dollars }
      end
    end

    context 'given YouTube responds to the second request with' do
      let(:behave) { receive(:flat_map).twice.and_raise Yt::Error, msg }

      context 'an Invalid Query error' do
        let(:error) { {reason: 'badRequest', message: message} }

        it { expect{collection.within date..date}.to raise_error Yt::Error }
      end

      context 'a Backend error' do
        let(:error) { {reason: 'backendError', message: 'Backend Error'} }

        it { expect{collection.within date..date}.to raise_error Yt::Error }
      end
    end
  end
end