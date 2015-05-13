# encoding: UTF-8
require 'spec_helper'
require 'yt/models/channel'
require 'yt/models/playlist'

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

      describe 'earnings can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }
        let(:keys) { range.values }

        specify 'with the :by option set to :range' do
          earnings = channel.earnings range.merge by: :range
          expect(earnings.size).to be 1
          expect(earnings[:total]).to be_a Float
        end
      end

      describe 'earnings can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          earnings = channel.earnings range
          expect(earnings.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          earnings = channel.earnings range.merge by: :day
          expect(earnings.keys).to eq range.values
        end
      end

      describe 'earnings can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          earnings = channel.earnings range.merge by: :country
          expect(earnings.keys).to all(be_a String)
          expect(earnings.keys.map(&:length).uniq).to eq [2]
          expect(earnings.values).to all(be_a Float)
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

      describe 'views can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          views = channel.views range.merge by: :range
          expect(views.size).to be 1
          expect(views[:total]).to be_an Integer
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

      describe 'views can be grouped by playback location' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }
        let(:keys) { Yt::Collections::Reports::PLAYBACK_LOCATIONS.keys }

        specify 'with the :by option set to :playback_location' do
          views = channel.views range.merge by: :playback_location
          expect(views.keys - keys).to be_empty
        end
      end

      describe 'views can be grouped by embedded player location' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :embedded_player_location' do
          views = channel.views range.merge by: :embedded_player_location
          expect(views).not_to be_empty
        end
      end

      describe 'views can be grouped by related video' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :related_video' do
          views = channel.views range.merge by: :related_video
          expect(views.keys).to all(be_instance_of Yt::Video)
        end
      end

      describe 'views can be grouped by video' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :video' do
          views = channel.views range.merge by: :video
          expect(views.keys).to all(be_instance_of Yt::Video)
        end
      end

      describe 'views can be grouped by playlist' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :playlist' do
          views = channel.views range.merge by: :playlist
          expect(views.keys).to all(be_instance_of Yt::Playlist)
        end
      end

      describe 'views can be grouped by device type' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :device_type' do
          views = channel.views range.merge by: :device_type
          expect(views.keys).to all(be_instance_of Symbol)
          expect(views.values).to all(be_an Integer)
        end
      end

      describe 'views can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          views = channel.views range.merge by: :country
          expect(views.keys).to all(be_a String)
          expect(views.keys.map(&:length).uniq).to eq [2]
          expect(views.values).to all(be_an Integer)
        end
      end

      describe 'comments can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:comments) { channel.comments_on 5.days.ago}
          it { expect(comments).to be_an Integer }
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

      describe 'comments can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          comments = channel.comments range.merge by: :range
          expect(comments.size).to be 1
          expect(comments[:total]).to be_an Integer
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

      describe 'comments can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          comments = channel.comments range.merge by: :country
          expect(comments.keys).to all(be_a String)
          expect(comments.keys.map(&:length).uniq).to eq [2]
          expect(comments.values).to all(be_an Integer)
        end
      end

      describe 'likes can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:likes) { channel.likes_on 5.days.ago}
          it { expect(likes).to be_an Integer }
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

      describe 'likes can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          likes = channel.likes range.merge by: :range
          expect(likes.size).to be 1
          expect(likes[:total]).to be_an Integer
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

      describe 'likes can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          likes = channel.likes range.merge by: :country
          expect(likes.keys).to all(be_a String)
          expect(likes.keys.map(&:length).uniq).to eq [2]
          expect(likes.values).to all(be_an Integer)
        end
      end

      describe 'dislikes can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:dislikes) { channel.dislikes_on 5.days.ago}
          it { expect(dislikes).to be_an Integer }
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

      describe 'dislikes can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          dislikes = channel.dislikes range.merge by: :range
          expect(dislikes.size).to be 1
          expect(dislikes[:total]).to be_an Integer
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

      describe 'dislikes can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          dislikes = channel.dislikes range.merge by: :country
          expect(dislikes.keys).to all(be_a String)
          expect(dislikes.keys.map(&:length).uniq).to eq [2]
          expect(dislikes.values).to all(be_an Integer)
        end
      end

      describe 'shares can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:date) { Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 95 }
          let(:shares) { channel.shares_on date }
          it { expect(shares).to be_an Integer }
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

      describe 'shares can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          shares = channel.shares range.merge by: :range
          expect(shares.size).to be 1
          expect(shares[:total]).to be_an Integer
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

      describe 'shares can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          shares = channel.shares range.merge by: :country
          expect(shares.keys).to all(be_a String)
          expect(shares.keys.map(&:length).uniq).to eq [2]
          expect(shares.values).to all(be_an Integer)
        end
      end

      describe 'gained subscribers can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:subscribers_gained) { channel.subscribers_gained_on 5.days.ago}
          it { expect(subscribers_gained).to be_an Integer }
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

      describe 'gained subscribers can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          subscribers_gained = channel.subscribers_gained range.merge by: :range
          expect(subscribers_gained.size).to be 1
          expect(subscribers_gained[:total]).to be_an Integer
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

      describe 'gained subscribers can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          subscribers_gained = channel.subscribers_gained range.merge by: :country
          expect(subscribers_gained.keys).to all(be_a String)
          expect(subscribers_gained.keys.map(&:length).uniq).to eq [2]
          expect(subscribers_gained.values).to all(be_an Integer)
        end
      end

      describe 'lost subscribers can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:subscribers_lost) { channel.subscribers_lost_on 5.days.ago}
          it { expect(subscribers_lost).to be_an Integer }
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

      describe 'lost subscribers can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          subscribers_lost = channel.subscribers_lost range.merge by: :range
          expect(subscribers_lost.size).to be 1
          expect(subscribers_lost[:total]).to be_an Integer
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

      describe 'lost subscribers can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          subscribers_lost = channel.subscribers_lost range.merge by: :country
          expect(subscribers_lost.keys).to all(be_a String)
          expect(subscribers_lost.keys.map(&:length).uniq).to eq [2]
          expect(subscribers_lost.values).to all(be_an Integer)
        end
      end

      describe 'added favorites can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:favorites_added) { channel.favorites_added_on 5.days.ago}
          it { expect(favorites_added).to be_an Integer }
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

      describe 'added favorites can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          favorites_added = channel.favorites_added range.merge by: :range
          expect(favorites_added.size).to be 1
          expect(favorites_added[:total]).to be_an Integer
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

      describe 'added favorites can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          favorites_added = channel.favorites_added range.merge by: :country
          expect(favorites_added.keys).to all(be_a String)
          expect(favorites_added.keys.map(&:length).uniq).to eq [2]
          expect(favorites_added.values).to all(be_an Integer)
        end
      end

      describe 'removed favorites can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:favorites_removed) { channel.favorites_removed_on 5.days.ago}
          it { expect(favorites_removed).to be_an Integer }
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

      describe 'removed favorites can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          favorites_removed = channel.favorites_removed range.merge by: :range
          expect(favorites_removed.size).to be 1
          expect(favorites_removed[:total]).to be_an Integer
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

      describe 'removed favorites can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          favorites_removed = channel.favorites_removed range.merge by: :country
          expect(favorites_removed.keys).to all(be_a String)
          expect(favorites_removed.keys.map(&:length).uniq).to eq [2]
          expect(favorites_removed.values).to all(be_an Integer)
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

      describe 'estimated minutes watched can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          minutes = channel.estimated_minutes_watched range.merge by: :range
          expect(minutes.size).to be 1
          expect(minutes[:total]).to be_a Float
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

      describe 'estimated minutes watched can be grouped by playback location' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }
        let(:keys) { Yt::Collections::Reports::PLAYBACK_LOCATIONS.keys }

        specify 'with the :by option set to :playback_location' do
          estimated_minutes_watched = channel.estimated_minutes_watched range.merge by: :playback_location
          expect(estimated_minutes_watched.keys - keys).to be_empty
        end
      end

      describe 'estimated minutes watched can be grouped by embedded player location' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :embedded_player_location' do
          estimated_minutes_watched = channel.estimated_minutes_watched range.merge by: :embedded_player_location
          expect(estimated_minutes_watched).not_to be_empty
        end
      end

      describe 'estimated minutes watched can be grouped by related video' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :related_video' do
          estimated_minutes_watched = channel.estimated_minutes_watched range.merge by: :related_video
          expect(estimated_minutes_watched.keys).to all(be_instance_of Yt::Video)
        end
      end

      describe 'estimated minutes watched can be grouped by video' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :video' do
          estimated_minutes_watched = channel.estimated_minutes_watched range.merge by: :video
          expect(estimated_minutes_watched.keys).to all(be_instance_of Yt::Video)
        end
      end

      describe 'estimated minutes watched can be grouped by playlist' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :playlist' do
          estimated_minutes_watched = channel.estimated_minutes_watched range.merge by: :playlist
          expect(estimated_minutes_watched.keys).to all(be_instance_of Yt::Playlist)
        end
      end

      describe 'estimated minutes watched can be grouped by device type' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :device_type' do
          estimated_minutes_watched = channel.estimated_minutes_watched range.merge by: :device_type
          expect(estimated_minutes_watched.keys).to all(be_instance_of Symbol)
          expect(estimated_minutes_watched.values).to all(be_instance_of Float)
        end
      end

      describe 'estimated minutes watched can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          minutes = channel.estimated_minutes_watched range.merge by: :country
          expect(minutes.keys).to all(be_a String)
          expect(minutes.keys.map(&:length).uniq).to eq [2]
          expect(minutes.values).to all(be_a Float)
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

      describe 'average view duration can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          duration = channel.average_view_duration range.merge by: :range
          expect(duration.size).to be 1
          expect(duration[:total]).to be_a Float
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

      describe 'average view duration can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          duration = channel.average_view_duration range.merge by: :country
          expect(duration.keys).to all(be_a String)
          expect(duration.keys.map(&:length).uniq).to eq [2]
          expect(duration.values).to all(be_a Float)
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

      describe 'average view percentage can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          percentage = channel.average_view_percentage range.merge by: :range
          expect(percentage.size).to be 1
          expect(percentage[:total]).to be_a Float
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

      describe 'average view percentage can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          percentage = channel.average_view_percentage range.merge by: :country
          expect(percentage.keys).to all(be_a String)
          expect(percentage.keys.map(&:length).uniq).to eq [2]
          expect(percentage.values).to all(be_a Float)
        end
      end

      describe 'impressions can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:impressions) { channel.impressions_on 20.days.ago}
          it { expect(impressions).to be_an Integer }
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

      describe 'impressions can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          impressions = channel.impressions range.merge by: :range
          expect(impressions.size).to be 1
          expect(impressions[:total]).to be_an Integer
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

      describe 'impressions can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          impressions = channel.impressions range.merge by: :country
          expect(impressions.keys).to all(be_a String)
          expect(impressions.keys.map(&:length).uniq).to eq [2]
          expect(impressions.values).to all(be_an Integer)
        end
      end

      describe 'monetized playbacks can be retrieved for a specific day' do
        context 'in which the channel was partnered' do
          let(:monetized_playbacks) { channel.monetized_playbacks_on 20.days.ago}
          it { expect(monetized_playbacks).to be_an Integer }
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

      describe 'monetized playbacks can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          monetized_playbacks = channel.monetized_playbacks range.merge by: :range
          expect(monetized_playbacks.size).to be 1
          expect(monetized_playbacks[:total]).to be_an Integer
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

      describe 'monetized playbacks can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          playbacks = channel.monetized_playbacks range.merge by: :country
          expect(playbacks.keys).to all(be_a String)
          expect(playbacks.keys.map(&:length).uniq).to eq [2]
          expect(playbacks.values).to all(be_an Integer)
        end
      end

      describe 'annotation clicks can be retrieved for a range of days' do
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }
        let(:date_to) { Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 5 }

        specify 'with a given start (:since option) and a given end (:until option)' do
          expect(channel.annotation_clicks(since: date, until: date_to).keys.min).to eq date.to_date
        end

        specify 'with a given start (:from option) and a given end (:to option)' do
          expect(channel.annotation_clicks(from: date, to: date_to).keys.min).to eq date.to_date
        end
      end

      describe 'annotation clicks can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          annotation_clicks = channel.annotation_clicks range.merge by: :range
          expect(annotation_clicks.size).to be 1
          expect(annotation_clicks[:total]).to be_an Integer
        end
      end

      describe 'annotation clicks can be grouped by day' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE'], until: Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 5} }

        specify 'without a :by option (default)' do
          annotation_clicks = channel.annotation_clicks range
          expect(annotation_clicks.values).to all(be_an Integer)
        end

        specify 'with the :by option set to :day' do
          annotation_clicks = channel.annotation_clicks range.merge by: :day
          expect(annotation_clicks.values).to all(be_an Integer)
        end
      end

      describe 'annotation clicks can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          clicks = channel.annotation_clicks range.merge by: :country
          expect(clicks.keys).to all(be_a String)
          expect(clicks.keys.map(&:length).uniq).to eq [2]
          expect(clicks.values).to all(be_an Integer)
        end
      end

      describe 'annotation click-through rate can be retrieved for a range of days' do
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }
        let(:date_to) { Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 5 }

        specify 'with a given start (:since option) and a given end (:until option)' do
          expect(channel.annotation_click_through_rate(since: date, until: date_to).keys.min).to eq date.to_date
        end

        specify 'with a given start (:from option) and a given end (:to option)' do
          expect(channel.annotation_click_through_rate(from: date, to: date_to).keys.min).to eq date.to_date
        end
      end

      describe 'annotation click-through rate can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          rate = channel.annotation_click_through_rate range.merge by: :range
          expect(rate.size).to be 1
          expect(rate[:total]).to be_a Float
        end
      end

      describe 'annotation click-through rate can be grouped by day' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE'], until: Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 5} }

        specify 'without a :by option (default)' do
          annotation_click_through_rate = channel.annotation_click_through_rate range
          expect(annotation_click_through_rate.values).to all(be_instance_of Float)
        end

        specify 'with the :by option set to :day' do
          annotation_click_through_rate = channel.annotation_click_through_rate range.merge by: :day
          expect(annotation_click_through_rate.values).to all(be_instance_of Float)
        end
      end

      describe 'annotation click-through rate can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          rate = channel.annotation_click_through_rate range.merge by: :country
          expect(rate.keys).to all(be_a String)
          expect(rate.keys.map(&:length).uniq).to eq [2]
          expect(rate.values).to all(be_a Float)
        end
      end

      describe 'annotation close rate can be retrieved for a range of days' do
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }
        let(:date_to) { Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 5 }

        specify 'with a given start (:since option) and a given end (:until option)' do
          expect(channel.annotation_close_rate(since: date, until: date_to).keys.min).to eq date.to_date
        end

        specify 'with a given start (:from option) and a given end (:to option)' do
          expect(channel.annotation_close_rate(from: date, to: date_to).keys.min).to eq date.to_date
        end
      end

      describe 'annotation close rate can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          rate = channel.annotation_close_rate range.merge by: :range
          expect(rate.size).to be 1
          expect(rate[:total]).to be_a Float
        end
      end

      describe 'annotation close rate can be grouped by day' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE'], until: Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 5} }

        specify 'without a :by option (default)' do
          annotation_close_rate = channel.annotation_close_rate range
          expect(annotation_close_rate.values).to all(be_instance_of Float)
        end

        specify 'with the :by option set to :day' do
          annotation_close_rate = channel.annotation_close_rate range.merge by: :day
          expect(annotation_close_rate.values).to all(be_instance_of Float)
        end
      end

      describe 'annotation close rate can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          rate = channel.annotation_close_rate range.merge by: :country
          expect(rate.keys).to all(be_a String)
          expect(rate.keys.map(&:length).uniq).to eq [2]
          expect(rate.values).to all(be_a Float)
        end
      end

      describe 'viewer percentage can be retrieved for a range of days' do
        let(:viewer_percentage) { channel.viewer_percentage since: 1.year.ago, until: 10.days.ago}
        it { expect(viewer_percentage).to be_a Hash }
      end

      describe 'viewer_percentage can be grouped by gender and age group' do
        let(:range) { {since: 1.year.ago.to_date, until: 1.week.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          viewer_percentage = channel.viewer_percentage range
          expect(viewer_percentage.keys).to match_array [:female, :male]
          expect(viewer_percentage[:female].keys - %w(65- 35-44 45-54 13-17 25-34 55-64 18-24)).to be_empty
          expect(viewer_percentage[:female].values).to all(be_instance_of Float)
          expect(viewer_percentage[:male].keys - %w(65- 35-44 45-54 13-17 25-34 55-64 18-24)).to be_empty
          expect(viewer_percentage[:male].values).to all(be_instance_of Float)
        end

        specify 'with the :by option set to :gender_age_group' do
          viewer_percentage = channel.viewer_percentage range.merge by: :gender_age_group
          expect(viewer_percentage.keys).to match_array [:female, :male]
          expect(viewer_percentage[:female].keys - %w(65- 35-44 45-54 13-17 25-34 55-64 18-24)).to be_empty
          expect(viewer_percentage[:female].values).to all(be_instance_of Float)
          expect(viewer_percentage[:male].keys - %w(65- 35-44 45-54 13-17 25-34 55-64 18-24)).to be_empty
          expect(viewer_percentage[:male].values).to all(be_instance_of Float)
        end
      end

      describe 'viewer_percentage can be grouped by gender' do
        let(:range) { {since: 1.year.ago.to_date, until: 1.week.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :gender' do
          viewer_percentage = channel.viewer_percentage range.merge by: :gender
          expect(viewer_percentage.keys).to match_array [:female, :male]
          expect(viewer_percentage[:female]).to be_a Float
          expect(viewer_percentage[:male]).to be_a Float
        end
      end

      describe 'viewer_percentage can be grouped by age group' do
        let(:range) { {since: 1.year.ago.to_date, until: 1.week.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :age_group' do
          viewer_percentage = channel.viewer_percentage range.merge by: :age_group
          expect(viewer_percentage.keys - %w(65- 35-44 45-54 13-17 25-34 55-64 18-24)).to be_empty
          expect(viewer_percentage.values).to all(be_instance_of Float)
        end
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