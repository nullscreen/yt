require 'spec_helper'

describe Yt::Associations::Earnings, :partner do
  context 'given a partnered channel' do
    let(:channel) { Yt::Channel.new id: channel_id, auth: $content_owner }

    context 'managed by the authenticated Content Owner' do
      let(:channel_id) { ENV['YT_TEST_PARTNER_CHANNEL_ID'] }

      describe '#earning' do
        context 'and a date in which the channel made any money' do
          let(:earning) { channel.earning 5.days.ago}
          it { expect(earning).to be_a Float }
        end

        # NOTE: This test sounds redundant, but it’s actually a reflection of
        # another irrational behavior of YouTube API. In short, if you ask for
        # the "earnings" metric of a day in which a channel made 0 USD, then
        # the API returns "nil". But if you also for the "earnings" metric AND
        # the "estimatedMinutesWatched" metric, then the API returns the
        # correct value of "0", while still returning nil for those days in
        # which the earnings have not been estimated yet.
        context 'and a date in which the channel did not make any money' do
          let(:zero_date) { ENV['YT_TEST_PARTNER_CHANNEL_NO_EARNINGS_DATE'] }
          let(:earning) { channel.earning zero_date}
          it { expect(earning).to eq 0 }
        end

        context 'and a date for which earnings have not yet been estimated' do
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