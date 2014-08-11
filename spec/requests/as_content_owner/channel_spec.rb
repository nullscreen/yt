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
          it { expect(views).to be_a Float }
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

      describe 'comments can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:comments) { channel.comments_on 5.days.ago}
          it { expect(comments).to be_a Float }
        end

        context 'in which the channel was not partnered' do
          let(:comments) { channel.comments_on 20.years.ago}
          it { expect(comments).to be_nil }
        end
      end

      describe 'comments can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(channel.comments(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(channel.comments(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(channel.comments(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(channel.comments(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'likes can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:likes) { channel.likes_on 5.days.ago}
          it { expect(likes).to be_a Float }
        end

        context 'in which the channel was not partnered' do
          let(:likes) { channel.likes_on 20.years.ago}
          it { expect(likes).to be_nil }
        end
      end

      describe 'likes can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(channel.likes(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(channel.likes(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(channel.likes(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(channel.likes(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'dislikes can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:dislikes) { channel.dislikes_on 5.days.ago}
          it { expect(dislikes).to be_a Float }
        end

        context 'in which the channel was not partnered' do
          let(:dislikes) { channel.dislikes_on 20.years.ago}
          it { expect(dislikes).to be_nil }
        end
      end

      describe 'dislikes can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(channel.dislikes(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(channel.dislikes(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(channel.dislikes(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(channel.dislikes(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'shares can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:shares) { channel.shares_on 5.days.ago}
          it { expect(shares).to be_a Float }
        end

        context 'in which the channel was not partnered' do
          let(:shares) { channel.shares_on 20.years.ago}
          it { expect(shares).to be_nil }
        end
      end

      describe 'shares can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(channel.shares(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(channel.shares(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(channel.shares(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(channel.shares(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'impressions can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:impressions) { channel.impressions_on 20.days.ago}
          it { expect(impressions).to be_a Float }
        end

        context 'in which the channel was not partnered' do
          let(:impressions) { channel.impressions_on 20.years.ago}
          it { expect(impressions).to be_nil }
        end
      end

      describe 'impressions can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(channel.impressions(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(channel.impressions(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(channel.impressions(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(channel.impressions(to: date).keys.max).to eq date.to_date
        end
      end

      specify 'viewer percentages by gender and age range can be retrieved' do
        expect(channel.viewer_percentages[:female]['18-24']).to be_a Float
        expect(channel.viewer_percentages[:female]['25-34']).to be_a Float
        expect(channel.viewer_percentages[:female]['35-44']).to be_a Float
        expect(channel.viewer_percentages[:female]['45-54']).to be_a Float
        expect(channel.viewer_percentages[:female]['55-64']).to be_a Float
        expect(channel.viewer_percentages[:female]['65-']).to be_a Float
        expect(channel.viewer_percentages[:male]['18-24']).to be_a Float
        expect(channel.viewer_percentages[:male]['25-34']).to be_a Float
        expect(channel.viewer_percentages[:male]['35-44']).to be_a Float
        expect(channel.viewer_percentages[:male]['45-54']).to be_a Float
        expect(channel.viewer_percentages[:male]['55-64']).to be_a Float
        expect(channel.viewer_percentages[:male]['65-']).to be_a Float

        expect(channel.viewer_percentage(gender: :male)).to be_a Float
        expect(channel.viewer_percentage(gender: :female)).to be_a Float
      end

      specify 'information about its content owner can be retrieved' do
        expect(channel.content_owner).to be_a String
        expect(channel.linked_at).to be_a Time
      end
    end

    context 'not managed by the authenticated Content Owner' do
      let(:id) { 'UCBR8-60-B28hp2BmDPdntcQ' }

      specify 'earnings and impressions cannot be retrieved' do
        expect{channel.earnings}.to raise_error Yt::Errors::Forbidden
        expect{channel.views}.to raise_error Yt::Errors::Forbidden
      end

      specify 'information about its content owner cannot be retrieved' do
        expect(channel.content_owner).to be_nil
        expect(channel.linked_at).to be_nil
      end
    end
  end
end