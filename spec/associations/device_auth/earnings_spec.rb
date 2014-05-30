require 'spec_helper'

describe Yt::Associations::Earnings, :partner do
  context 'given a Youtube Partner channel (with a content owner)' do
    let(:channel) { $partner_channel }

    describe '#earning' do
      context 'given a date for which YouTube has estimated earnings' do
        let(:earning) { channel.earning 5.days.ago}
        it { expect(earning).to be_a Float }
      end

      context 'given a date for which YouTube does not have estimated earnings' do
        let(:earning) { channel.earning 5.days.from_now}
        it { expect(earning).to be_nil }
      end
    end

    describe '#earning' do
      let(:date) { 4.days.ago }

      context 'given a :since option' do
        let(:earnings) { channel.earnings since: date}
        it { expect(earnings.keys.min).to eq date.to_date }
      end

      context 'given a :from option' do
        let(:earnings) { channel.earnings from: date}
        it { expect(earnings.keys.min).to eq date.to_date }
      end

      context 'given a :until option' do
        let(:earnings) { channel.earnings until: date}
        it { expect(earnings.keys.max).to eq date.to_date }
      end

      context 'given a :to option' do
        let(:earnings) { channel.earnings to: date}
        it { expect(earnings.keys.max).to eq date.to_date }
      end
    end
  end
end