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

      describe 'views can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          views = channel.views range
          expect(views.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          views = channel.views range.merge by: :day
          expect(views.keys).to eq range.values
        end
      end

      describe 'views can be grouped by traffic source' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }
        let(:keys) { Yt::Collections::Reports::TRAFFIC_SOURCES.keys }

        specify 'with the :by option set to :traffic_source' do
          views = channel.views range.merge by: :traffic_source
          expect(views.keys - keys).to be_empty
        end
      end

      describe 'views can be grouped by video' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :video' do
          views = channel.views range.merge by: :video
          expect(views.keys).to all(be_instance_of Yt::Video)
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

      describe 'comments can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          comments = channel.comments range
          expect(comments.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          comments = channel.comments range.merge by: :day
          expect(comments.keys).to eq range.values
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

      describe 'likes can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          likes = channel.likes range
          expect(likes.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          likes = channel.likes range.merge by: :day
          expect(likes.keys).to eq range.values
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

      describe 'dislikes can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          dislikes = channel.dislikes range
          expect(dislikes.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          dislikes = channel.dislikes range.merge by: :day
          expect(dislikes.keys).to eq range.values
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

      describe 'shares can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          shares = channel.shares range
          expect(shares.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          shares = channel.shares range.merge by: :day
          expect(shares.keys).to eq range.values
        end
      end

      describe 'gained subscribers can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:subscribers_gained) { channel.subscribers_gained_on 5.days.ago}
          it { expect(subscribers_gained).to be_a Float }
        end

        context 'in which the channel was not partnered' do
          let(:subscribers_gained) { channel.subscribers_gained_on 20.years.ago}
          it { expect(subscribers_gained).to be_nil }
        end
      end

      describe 'gained subscribers can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(channel.subscribers_gained(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(channel.subscribers_gained(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(channel.subscribers_gained(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(channel.subscribers_gained(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'gained subscribers can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          subscribers_gained = channel.subscribers_gained range
          expect(subscribers_gained.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          subscribers_gained = channel.subscribers_gained range.merge by: :day
          expect(subscribers_gained.keys).to eq range.values
        end
      end

      describe 'lost subscribers can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:subscribers_lost) { channel.subscribers_lost_on 5.days.ago}
          it { expect(subscribers_lost).to be_a Float }
        end

        context 'in which the channel was not partnered' do
          let(:subscribers_lost) { channel.subscribers_lost_on 20.years.ago}
          it { expect(subscribers_lost).to be_nil }
        end
      end

      describe 'lost subscribers can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(channel.subscribers_lost(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(channel.subscribers_lost(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(channel.subscribers_lost(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(channel.subscribers_lost(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'lost subscribers can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          subscribers_lost = channel.subscribers_lost range
          expect(subscribers_lost.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          subscribers_lost = channel.subscribers_lost range.merge by: :day
          expect(subscribers_lost.keys).to eq range.values
        end
      end

      describe 'added favorites can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:favorites_added) { channel.favorites_added_on 5.days.ago}
          it { expect(favorites_added).to be_a Float }
        end

        context 'in which the channel was not partnered' do
          let(:favorites_added) { channel.favorites_added_on 20.years.ago}
          it { expect(favorites_added).to be_nil }
        end
      end

      describe 'added favorites can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(channel.favorites_added(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(channel.favorites_added(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(channel.favorites_added(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(channel.favorites_added(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'added favorites can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          favorites_added = channel.favorites_added range
          expect(favorites_added.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          favorites_added = channel.favorites_added range.merge by: :day
          expect(favorites_added.keys).to eq range.values
        end
      end

      describe 'removed favorites can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:favorites_removed) { channel.favorites_removed_on 5.days.ago}
          it { expect(favorites_removed).to be_a Float }
        end

        context 'in which the channel was not partnered' do
          let(:favorites_removed) { channel.favorites_removed_on 20.years.ago}
          it { expect(favorites_removed).to be_nil }
        end
      end

      describe 'removed favorites can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(channel.favorites_removed(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(channel.favorites_removed(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(channel.favorites_removed(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(channel.favorites_removed(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'removed favorites can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          favorites_removed = channel.favorites_removed range
          expect(favorites_removed.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          favorites_removed = channel.favorites_removed range.merge by: :day
          expect(favorites_removed.keys).to eq range.values
        end
      end

      describe 'estimated minutes watched can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:estimated_minutes_watched) { channel.estimated_minutes_watched_on 5.days.ago}
          it { expect(estimated_minutes_watched).to be_a Float }
        end

        context 'in which the channel was not partnered' do
          let(:estimated_minutes_watched) { channel.estimated_minutes_watched_on 20.years.ago}
          it { expect(estimated_minutes_watched).to be_nil }
        end
      end

      describe 'estimated minutes watched can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(channel.estimated_minutes_watched(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(channel.estimated_minutes_watched(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(channel.estimated_minutes_watched(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(channel.estimated_minutes_watched(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'estimated minutes watched can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          estimated_minutes_watched = channel.estimated_minutes_watched range
          expect(estimated_minutes_watched.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          estimated_minutes_watched = channel.estimated_minutes_watched range.merge by: :day
          expect(estimated_minutes_watched.keys).to eq range.values
        end
      end

      describe 'estimated minutes watched can be grouped by traffic source' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }
        let(:keys) { Yt::Collections::Reports::TRAFFIC_SOURCES.keys }

        specify 'with the :by option set to :traffic_source' do
          estimated_minutes_watched = channel.estimated_minutes_watched range.merge by: :traffic_source
          expect(estimated_minutes_watched.keys - keys).to be_empty
        end
      end

      describe 'estimated minutes watched can be grouped by video' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :video' do
          estimated_minutes_watched = channel.estimated_minutes_watched range.merge by: :video
          expect(estimated_minutes_watched.keys).to all(be_instance_of Yt::Video)
        end
      end

      describe 'average view duration can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:average_view_duration) { channel.average_view_duration_on 5.days.ago}
          it { expect(average_view_duration).to be_a Float }
        end

        context 'in which the channel was not partnered' do
          let(:average_view_duration) { channel.average_view_duration_on 20.years.ago}
          it { expect(average_view_duration).to be_nil }
        end
      end

      describe 'average view duration can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(channel.average_view_duration(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(channel.average_view_duration(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(channel.average_view_duration(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(channel.average_view_duration(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'average view duration can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          average_view_duration = channel.average_view_duration range
          expect(average_view_duration.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          average_view_duration = channel.average_view_duration range.merge by: :day
          expect(average_view_duration.keys).to eq range.values
        end
      end

      describe 'average view percentage can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:average_view_percentage) { channel.average_view_percentage_on 5.days.ago}
          it { expect(average_view_percentage).to be_a Float }
        end

        context 'in which the channel was not partnered' do
          let(:average_view_percentage) { channel.average_view_percentage_on 20.years.ago}
          it { expect(average_view_percentage).to be_nil }
        end
      end

      describe 'average view percentage can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(channel.average_view_percentage(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(channel.average_view_percentage(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(channel.average_view_percentage(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(channel.average_view_percentage(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'average view percentage can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          average_view_percentage = channel.average_view_percentage range
          expect(average_view_percentage.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          average_view_percentage = channel.average_view_percentage range.merge by: :day
          expect(average_view_percentage.keys).to eq range.values
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

      describe 'impressions can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          impressions = channel.impressions range
          expect(impressions.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          impressions = channel.impressions range.merge by: :day
          expect(impressions.keys).to eq range.values
        end
      end

      describe 'monetized playbacks can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:monetized_playbacks) { channel.monetized_playbacks_on 20.days.ago}
          it { expect(monetized_playbacks).to be_a Float }
        end

        context 'in which the channel was not partnered' do
          let(:monetized_playbacks) { channel.monetized_playbacks_on 20.years.ago}
          it { expect(monetized_playbacks).to be_nil }
        end
      end

      describe 'monetized playbacks can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(channel.monetized_playbacks(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(channel.monetized_playbacks(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(channel.monetized_playbacks(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(channel.monetized_playbacks(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'monetized_playbacks can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          monetized_playbacks = channel.monetized_playbacks range
          expect(monetized_playbacks.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          monetized_playbacks = channel.monetized_playbacks range.merge by: :day
          expect(monetized_playbacks.keys).to eq range.values
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