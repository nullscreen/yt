require 'spec_helper'

describe Yt::Associations::Earnings, :partner do
  context 'given a partnered channel' do
    let(:channel) { Yt::Channel.new id: channel_id, auth: $content_owner }

    context 'managed by the authenticated Content Owner' do
      let(:channel_id) { ENV['YT_TEST_PARTNER_CHANNEL_ID'] }

      describe '#earning' do
        context 'given a date for which YouTube estimated earnings' do
          let(:earning) { channel.earning 5.days.ago}
          it { expect(earning).to be_a Float }
        end

        context 'given a date for which YouTube did not estimate earnings' do
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

    context 'not managed by the authenticated Content Owner' do
      let(:channel_id) { 'UCBR8-60-B28hp2BmDPdntcQ' }
      it { expect{channel.earning 5.days.ago}.to raise_error Yt::Errors::Forbidden }
    end
  end
end