# encoding: UTF-8
require 'spec_helper'
require 'yt/models/channel'

describe Yt::Channel, :partner do
  subject(:channel) { Yt::Channel.new id: id, auth: $content_owner }

  context 'given a partnered channel', :partner do
    context 'managed by the authenticated Content Owner' do
      let(:id) { ENV['YT_TEST_PARTNER_CHANNEL_ID'] }

      describe 'earnings can be retrieved for a specific day' do
        context 'in which the channel made any money' do
          let(:earnings) { channel.earnings_on 5.days.ago}
          it { expect(earnings).to be_a Float }
        end

        # NOTE: This test sounds redundant, but it’s actually a reflection of
        # another irrational behavior of YouTube API. In short, if you ask for
        # the "earnings" metric of a day in which a channel made 0 USD, then
        # the API returns "nil". But if you also for the "earnings" metric AND
        # the "estimatedMinutesWatched" metric, then the API returns the
        # correct value of "0", while still returning nil for those days in
        # which the earnings have not been estimated yet.
        context 'in which the channel did not make any money' do
          let(:zero_date) { ENV['YT_TEST_PARTNER_CHANNEL_NO_EARNINGS_DATE'] }
          let(:earnings) { channel.earnings_on zero_date}
          it { expect(earnings).to eq 0 }
        end

        context 'in the future' do
          let(:earnings) { channel.earnings_on 5.days.from_now}
          it { expect(earnings).to be_nil }
        end
      end

      describe 'earnings can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(channel.earnings(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(channel.earnings(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(channel.earnings(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(channel.earnings(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'views can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:views) { channel.views_on 5.days.ago}
          it { expect(views).to be_an Integer }
        end

        context 'in which the channel was not partnered' do
          let(:views) { channel.views_on 20.years.ago}
          it { expect(views).to be_nil }
        end
      end

      describe 'views can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(channel.views(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(channel.views(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(channel.views(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(channel.views(to: date).keys.max).to eq date.to_date
        end
      end
    end

    context 'not managed by the authenticated Content Owner' do
      let(:id) { 'UCBR8-60-B28hp2BmDPdntcQ' }

      it { expect{channel.earnings}.to raise_error Yt::Errors::Forbidden }
      it { expect{channel.views}.to raise_error Yt::Errors::Forbidden }
    end
  end
end