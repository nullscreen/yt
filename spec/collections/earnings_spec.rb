require 'spec_helper'
require 'yt/collections/earnings'

describe Yt::Collections::Earnings do
  subject(:collection) { Yt::Collections::Earnings.new parent: channel }
  let(:channel) { Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow' }
  let(:message) { {response_body: {error: {errors: [error]}}}.to_json }
  let(:date) { 1.day.ago.to_date }
  let(:dollars) { 10 }

  describe '#within' do
    context 'given YouTube responds with a list of earnings' do
      before { collection.stub(:flat_map).and_return [date, dollars] }
      it { expect(collection.within(date..date)[date]).to eq dollars }
    end

    # NOTE: This test is just a reflection of YouTube irrational behavior
    # of raising a 400 error once in a while when retrieving earnings.
    # Hopefully this will get fixed and this code (and test) removed.
    context 'given YouTube responds with "Invalid query" the first time' do
      let(:msg) { 'Invalid query. Query did not conform to the expectations.' }
      let(:error) { {reason: 'badRequest', message: msg} }
      before do
        collection.stub :flat_map do
          collection.stub(:flat_map).and_return [date, dollars]
          raise Yt::Error, message
        end
      end

      it { expect(collection.within(date..date)[date]).to eq dollars }
    end

    context 'given YouTube responds with "Invalid query" the second time' do
      let(:msg) { 'Invalid query. Query did not conform to the expectations.' }
      let(:error) { {reason: 'badRequest', message: msg} }
      before { collection.stub(:flat_map).and_raise Yt::Error, message }

      it { expect{collection.within date..date}.to raise_error Yt::Error }
    end
  end
end