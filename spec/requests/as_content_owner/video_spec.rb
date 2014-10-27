# encoding: UTF-8
require 'spec_helper'
require 'yt/models/video'

describe Yt::Video, :partner do
  subject(:video) { Yt::Video.new id: id, auth: $content_owner }

  context 'given a video of a partnered channel', :partner do
    context 'managed by the authenticated Content Owner' do
      let(:id) { ENV['YT_TEST_VIDEO_CHANNEL_ID'] }

      describe 'advertising options can be retrieved' do
        it { expect{video.advertising_options_set}.not_to raise_error }
      end

      describe 'earnings can be retrieved for a specific day' do
        context 'in which the video made any money' do
          let(:earnings) {video.earnings_on 5.days.ago}
          it { expect(earnings).to be_a Float }
        end

        context 'in the future' do
          let(:earnings) { video.earnings_on 5.days.from_now}
          it { expect(earnings).to be_nil }
        end
      end

      describe 'earnings can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(video.earnings(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(video.earnings(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(video.earnings(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(video.earnings(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'views can be retrieved for a specific day' do
        context 'in which the video was partnered' do
          let(:views) { video.views_on 5.days.ago}
          it { expect(views).to be_a Float }
        end

        context 'in which the video was not partnered' do
          let(:views) { video.views_on 20.years.ago}
          it { expect(views).to be_nil }
        end
      end

      describe 'views can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(video.views(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(video.views(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(video.views(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(video.views(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'comments can be retrieved for a specific day' do
        context 'in which the video was partnered' do
          let(:comments) { video.comments_on 5.days.ago}
          it { expect(comments).to be_a Float }
        end

        context 'in which the video was not partnered' do
          let(:comments) { video.comments_on 20.years.ago}
          it { expect(comments).to be_nil }
        end
      end

      describe 'comments can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(video.comments(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(video.comments(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(video.comments(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(video.comments(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'likes can be retrieved for a specific day' do
        context 'in which the video was partnered' do
          let(:likes) { video.likes_on 5.days.ago}
          it { expect(likes).to be_a Float }
        end

        context 'in which the video was not partnered' do
          let(:likes) { video.likes_on 20.years.ago}
          it { expect(likes).to be_nil }
        end
      end

      describe 'likes can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(video.likes(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(video.likes(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(video.likes(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(video.likes(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'dislikes can be retrieved for a specific day' do
        context 'in which the video was partnered' do
          let(:dislikes) { video.dislikes_on 5.days.ago}
          it { expect(dislikes).to be_a Float }
        end

        context 'in which the video was not partnered' do
          let(:dislikes) { video.dislikes_on 20.years.ago}
          it { expect(dislikes).to be_nil }
        end
      end

      describe 'dislikes can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(video.dislikes(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(video.dislikes(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(video.dislikes(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(video.dislikes(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'shares can be retrieved for a specific day' do
        context 'in which the video was partnered' do
          let(:shares) { video.shares_on 5.days.ago}
          it { expect(shares).to be_a Float }
        end

        context 'in which the video was not partnered' do
          let(:shares) { video.shares_on 20.years.ago}
          it { expect(shares).to be_nil }
        end
      end

      describe 'shares can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(video.shares(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(video.shares(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(video.shares(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(video.shares(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'impressions can be retrieved for a specific day' do
        context 'in which the video was partnered' do
          let(:impressions) { video.impressions_on 20.days.ago}
          it { expect(impressions).to be_a Float }
        end

        context 'in which the video was not partnered' do
          let(:impressions) { video.impressions_on 20.years.ago}
          it { expect(impressions).to be_nil }
        end
      end

      describe 'impressions can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(video.impressions(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(video.impressions(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(video.impressions(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(video.impressions(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'monetized playbacks can be retrieved for a specific day' do
        context 'in which the video was partnered' do
          let(:monetized_playbacks) { video.monetized_playbacks_on 20.days.ago}
          it { expect(monetized_playbacks).to be_a Float }
        end

        context 'in which the video was not partnered' do
          let(:monetized_playbacks) { video.monetized_playbacks_on 20.years.ago}
          it { expect(monetized_playbacks).to be_nil }
        end
      end

      describe 'monetized playbacks can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(video.monetized_playbacks(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(video.monetized_playbacks(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(video.monetized_playbacks(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(video.monetized_playbacks(to: date).keys.max).to eq date.to_date
        end
      end

      specify 'viewer percentages by gender and age range can be retrieved' do
        expect(video.viewer_percentages[:female]['18-24']).to be_a Float
        expect(video.viewer_percentages[:female]['25-34']).to be_a Float
        expect(video.viewer_percentages[:female]['35-44']).to be_a Float
        expect(video.viewer_percentages[:female]['45-54']).to be_a Float
        expect(video.viewer_percentages[:female]['55-64']).to be_a Float
        expect(video.viewer_percentages[:female]['65-']).to be_a Float
        expect(video.viewer_percentages[:male]['18-24']).to be_a Float
        expect(video.viewer_percentages[:male]['25-34']).to be_a Float
        expect(video.viewer_percentages[:male]['35-44']).to be_a Float
        expect(video.viewer_percentages[:male]['45-54']).to be_a Float
        expect(video.viewer_percentages[:male]['55-64']).to be_a Float
        expect(video.viewer_percentages[:male]['65-']).to be_a Float

        expect(video.viewer_percentage(gender: :male)).to be_a Float
        expect(video.viewer_percentage(gender: :female)).to be_a Float
      end
    end

    context 'given a video claimable by the authenticated Content Owner' do
      let(:id) { ENV['YT_TEST_PARTNER_CLAIMABLE_VIDEO_ID'] }

      describe 'the advertising formats can be updated and retrieved' do
        let!(:old_formats) { video.ad_formats }
        let!(:new_formats) { %w(standard_instream overlay trueview_instream).sample(2) }
        before { video.advertising_options_set.update ad_formats: new_formats }
        it { expect(video.ad_formats).to match_array new_formats }
        after { video.advertising_options_set.update ad_formats: old_formats }
      end
    end
  end
end