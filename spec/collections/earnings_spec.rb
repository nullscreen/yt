require 'spec_helper'
require 'yt/collections/earnings'

describe Yt::Collections::Earnings do
  subject(:collection) { Yt::Collections::Earnings.new parent: channel }
  let(:channel) { Yt::Channel.new id: 'UCxO1tY8h1AhOz0T4ENwmpow' }
  let(:date) { 1.day.ago.to_date }
  let(:dollars) { 10 }
  before { expect(collection).to behave }

  describe '#within' do
    context 'given YouTube responds with a list of earnings' do
      let(:behave) { receive(:flat_map).and_return [date, dollars] }

      it { expect(collection.within(date..date)[date]).to eq dollars }
    end
  end
end