# encoding: UTF-8
require 'spec_helper'
require 'yt/models/video'

describe Yt::Video, :partner do
  subject(:video) { Yt::Video.new id: id, auth: $content_owner }

  context 'given a video of a partnered channel', :partner do
    context 'managed by the authenticated Content Owner' do
      let(:id) { ENV['YT_TEST_PARTNER_VIDEO_ID'] }

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

      describe 'views can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          views = video.views range
          expect(views.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          views = video.views range.merge by: :day
          expect(views.keys).to eq range.values
        end
      end

      describe 'views can be grouped by traffic source' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }
        let(:keys) { Yt::Collections::Reports::TRAFFIC_SOURCES.keys }

        specify 'with the :by option set to :traffic_source' do
          views = video.views range.merge by: :traffic_source
          expect(views.keys - keys).to be_empty
        end
      end

      describe 'views can be grouped by playback location' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }
        let(:keys) { Yt::Collections::Reports::PLAYBACK_LOCATIONS.keys }

        specify 'with the :by option set to :playback_location' do
          views = video.views range.merge by: :playback_location
          expect(views.keys - keys).to be_empty
        end
      end

      describe 'views can be grouped by embedded player location' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :embedded_player_location' do
          views = video.views range.merge by: :embedded_player_location
          expect(views).not_to be_empty
        end
      end

      describe 'views can be grouped by related video' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :related_video' do
          views = video.views range.merge by: :related_video
          expect(views.keys).to all(be_instance_of Yt::Video)
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

      describe 'comments can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          comments = video.comments range
          expect(comments.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          comments = video.comments range.merge by: :day
          expect(comments.keys).to eq range.values
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

      describe 'likes can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          likes = video.likes range
          expect(likes.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          likes = video.likes range.merge by: :day
          expect(likes.keys).to eq range.values
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

      describe 'dislikes can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          dislikes = video.dislikes range
          expect(dislikes.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          dislikes = video.dislikes range.merge by: :day
          expect(dislikes.keys).to eq range.values
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

      describe 'shares can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          shares = video.shares range
          expect(shares.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          shares = video.shares range.merge by: :day
          expect(shares.keys).to eq range.values
        end
      end

      describe 'gained subscribers can be retrieved for a specific day' do
        context 'in which the video was partnered' do
          let(:subscribers_gained) { video.subscribers_gained_on 5.days.ago}
          it { expect(subscribers_gained).to be_a Float }
        end

        context 'in which the video was not partnered' do
          let(:subscribers_gained) { video.subscribers_gained_on 20.years.ago}
          it { expect(subscribers_gained).to be_nil }
        end
      end

      describe 'gained subscribers can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(video.subscribers_gained(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(video.subscribers_gained(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(video.subscribers_gained(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(video.subscribers_gained(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'gained subscribers can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          subscribers_gained = video.subscribers_gained range
          expect(subscribers_gained.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          subscribers_gained = video.subscribers_gained range.merge by: :day
          expect(subscribers_gained.keys).to eq range.values
        end
      end

      describe 'lost subscribers can be retrieved for a specific day' do
        context 'in which the video was partnered' do
          let(:subscribers_lost) { video.subscribers_lost_on 5.days.ago}
          it { expect(subscribers_lost).to be_a Float }
        end

        context 'in which the video was not partnered' do
          let(:subscribers_lost) { video.subscribers_lost_on 20.years.ago}
          it { expect(subscribers_lost).to be_nil }
        end
      end

      describe 'lost subscribers can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(video.subscribers_lost(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(video.subscribers_lost(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(video.subscribers_lost(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(video.subscribers_lost(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'lost subscribers can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          subscribers_lost = video.subscribers_lost range
          expect(subscribers_lost.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          subscribers_lost = video.subscribers_lost range.merge by: :day
          expect(subscribers_lost.keys).to eq range.values
        end
      end

      describe 'added favorites can be retrieved for a specific day' do
        context 'in which the video was partnered' do
          let(:favorites_added) { video.favorites_added_on 5.days.ago}
          it { expect(favorites_added).to be_a Float }
        end

        context 'in which the video was not partnered' do
          let(:favorites_added) { video.favorites_added_on 20.years.ago}
          it { expect(favorites_added).to be_nil }
        end
      end

      describe 'added favorites can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(video.favorites_added(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(video.favorites_added(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(video.favorites_added(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(video.favorites_added(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'added favorites can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          favorites_added = video.favorites_added range
          expect(favorites_added.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          favorites_added = video.favorites_added range.merge by: :day
          expect(favorites_added.keys).to eq range.values
        end
      end

      describe 'removed favorites can be retrieved for a specific day' do
        context 'in which the video was partnered' do
          let(:favorites_removed) { video.favorites_removed_on 5.days.ago}
          it { expect(favorites_removed).to be_a Float }
        end

        context 'in which the video was not partnered' do
          let(:favorites_removed) { video.favorites_removed_on 20.years.ago}
          it { expect(favorites_removed).to be_nil }
        end
      end

      describe 'removed favorites can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(video.favorites_removed(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(video.favorites_removed(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(video.favorites_removed(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(video.favorites_removed(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'removed favorites can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          favorites_removed = video.favorites_removed range
          expect(favorites_removed.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          favorites_removed = video.favorites_removed range.merge by: :day
          expect(favorites_removed.keys).to eq range.values
        end
      end

      describe 'estimated minutes watched can be retrieved for a specific day' do
        context 'in which the video was partnered' do
          let(:estimated_minutes_watched) { video.estimated_minutes_watched_on 5.days.ago}
          it { expect(estimated_minutes_watched).to be_a Float }
        end

        context 'in which the video was not partnered' do
          let(:estimated_minutes_watched) { video.estimated_minutes_watched_on 20.years.ago}
          it { expect(estimated_minutes_watched).to be_nil }
        end
      end

      describe 'estimated minutes watched can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(video.estimated_minutes_watched(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(video.estimated_minutes_watched(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(video.estimated_minutes_watched(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(video.estimated_minutes_watched(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'estimated minutes watched can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          estimated_minutes_watched = video.estimated_minutes_watched range
          expect(estimated_minutes_watched.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          estimated_minutes_watched = video.estimated_minutes_watched range.merge by: :day
          expect(estimated_minutes_watched.keys).to eq range.values
        end
      end

      describe 'estimated minutes watched can be grouped by traffic source' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }
        let(:keys) { Yt::Collections::Reports::TRAFFIC_SOURCES.keys }

        specify 'with the :by option set to :traffic_source' do
          estimated_minutes_watched = video.estimated_minutes_watched range.merge by: :traffic_source
          expect(estimated_minutes_watched.keys - keys).to be_empty
        end
      end

      describe 'average view duration can be retrieved for a specific day' do
        context 'in which the video was partnered' do
          let(:average_view_duration) { video.average_view_duration_on 5.days.ago}
          it { expect(average_view_duration).to be_a Float }
        end

        context 'in which the video was not partnered' do
          let(:average_view_duration) { video.average_view_duration_on 20.years.ago}
          it { expect(average_view_duration).to be_nil }
        end
      end

      describe 'average view duration can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(video.average_view_duration(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(video.average_view_duration(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(video.average_view_duration(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(video.average_view_duration(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'average view duration can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          average_view_duration = video.average_view_duration range
          expect(average_view_duration.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          average_view_duration = video.average_view_duration range.merge by: :day
          expect(average_view_duration.keys).to eq range.values
        end
      end

      describe 'average view percentage can be retrieved for a specific day' do
        context 'in which the video was partnered' do
          let(:average_view_percentage) { video.average_view_percentage_on 5.days.ago}
          it { expect(average_view_percentage).to be_a Float }
        end

        context 'in which the video was not partnered' do
          let(:average_view_percentage) { video.average_view_percentage_on 20.years.ago}
          it { expect(average_view_percentage).to be_nil }
        end
      end

      describe 'average view percentage can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(video.average_view_percentage(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(video.average_view_percentage(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(video.average_view_percentage(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(video.average_view_percentage(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'average view percentage can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          average_view_percentage = video.average_view_percentage range
          expect(average_view_percentage.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          average_view_percentage = video.average_view_percentage range.merge by: :day
          expect(average_view_percentage.keys).to eq range.values
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

      describe 'impressions can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          impressions = video.impressions range
          expect(impressions.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          impressions = video.impressions range.merge by: :day
          expect(impressions.keys).to eq range.values
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

      describe 'monetized_playbacks can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          monetized_playbacks = video.monetized_playbacks range
          expect(monetized_playbacks.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          monetized_playbacks = video.monetized_playbacks range.merge by: :day
          expect(monetized_playbacks.keys).to eq range.values
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