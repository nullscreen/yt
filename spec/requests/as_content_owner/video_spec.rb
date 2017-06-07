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

      [:views, :comments, :likes, :dislikes, :shares,
       :subscribers_gained, :subscribers_lost,
       :videos_added_to_playlists, :videos_removed_from_playlists,
       :estimated_minutes_watched, :average_view_duration,
       :average_view_percentage, :ad_impressions, :monetized_playbacks,
       :annotation_clicks, :annotation_click_through_rate, :playback_based_cpm,
       :card_impressions, :card_clicks, :card_click_rate,
       :card_teaser_impressions, :card_teaser_clicks, :card_teaser_click_rate,
       :annotation_close_rate, :estimated_revenue].each do |metric|
        describe "#{metric} can be retrieved for a range of days" do
          let(:date_in) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }
          let(:date_out) { Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 5 }
          let(:metric) { metric }
          let(:result) { video.public_send metric, options }

          context 'with a given start and end (:since/:until option)' do
            let(:options) { {by: :day, since: date_in, until: date_out} }
            specify do
              expect(result.keys.min).to eq date_in.to_date
              expect(result.keys.max).to eq date_out.to_date
            end
          end

          context 'with a given start and end (:from/:to option)' do
            let(:options) { {by: :day, from: date_in, to: date_out} }
            specify do
              expect(result.keys.min).to eq date_in.to_date
              expect(result.keys.max).to eq date_out.to_date
            end
          end
        end

        describe "#{metric} can be grouped by month" do
          let(:metric) { metric }

          let(:result) { video.public_send metric, by: :month, since: 1.month.ago }
          specify do
            expect(result.keys).to all(be_a Range)
            expect(result.keys.map &:first).to all(be_a Date)
            expect(result.keys.map &:first).to eq result.keys.map(&:first).map(&:beginning_of_month)
            expect(result.keys.map &:last).to all(be_a Date)
            expect(result.keys.map &:last).to eq result.keys.map(&:last).map(&:end_of_month)
          end
        end

        describe "#{metric} can be grouped by week and returns non-overlapping periods" do
          let(:metric) { metric }
          let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE'], until: Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 9} }
          let(:result) { video.public_send metric, range.merge(by: :week)}
          specify do
            expect(result.size).to be <= 2
            expect(result.keys).to all(be_a Range)
            expect(result.keys.map{|range| range.first.wday}.uniq).to be_one
            expect(result.keys.map{|range| range.last.wday}.uniq).to be_one
          end
        end

        describe "#{metric} can be retrieved for a single country" do
          let(:result) { video.public_send metric, options }

          context 'and grouped by day' do
            let(:date_in) { 5.days.ago }
            let(:options) { {by: :day, since: date_in, in: location} }

            context 'with the :in option set to the country code' do
              let(:location) { 'US' }
              it { expect(result.keys.min).to eq date_in.to_date }
            end

            context 'with the :in option set to {country: country code}' do
              let(:location) { {country: 'US'} }
              it { expect(result.keys.min).to eq date_in.to_date }
            end
          end
        end
      end

      {views: Integer, comments: Integer, likes: Integer, dislikes: Integer,
       shares: Integer, subscribers_gained: Integer, subscribers_lost: Integer,
       videos_added_to_playlists: Integer, videos_removed_from_playlists: Integer,
       estimated_minutes_watched: Integer, average_view_duration: Integer,
       average_view_percentage: Float, ad_impressions: Integer,
       monetized_playbacks: Integer, annotation_clicks: Integer,
       annotation_click_through_rate: Float, annotation_close_rate: Float,
       card_impressions: Integer, card_clicks: Integer,
       card_click_rate: Float, card_teaser_impressions: Integer,
       card_teaser_clicks: Integer, card_teaser_click_rate: Float,
       estimated_revenue: Float}.each do |metric, type|
        describe "#{metric} can be grouped by range" do
          let(:metric) { metric }

          context 'without a :by option (default)' do
            let(:result) { video.public_send metric }
            specify do
              expect(result.size).to be 1
              expect(result[:total]).to be_a type
            end
          end

          context 'with the :by option set to :range' do
            let(:result) { video.public_send metric, by: :range }
            specify do
              expect(result.size).to be 1
              expect(result[:total]).to be_a type
            end
          end
        end
      end

      [:views, :comments, :likes, :dislikes, :shares,
       :subscribers_gained, :subscribers_lost,
       :videos_added_to_playlists, :videos_removed_from_playlists,
       :estimated_minutes_watched, :average_view_duration,
       :average_view_percentage, :ad_impressions, :monetized_playbacks,
       :card_impressions, :card_clicks, :card_click_rate,
       :card_teaser_impressions, :card_teaser_clicks, :card_teaser_click_rate,
       :annotation_clicks, :annotation_click_through_rate,
       :annotation_close_rate, :estimated_revenue].each do |metric|
        describe "#{metric} can be retrieved for a single country" do
          let(:result) { video.public_send metric, options }

          context 'and grouped by country' do
            let(:options) { {by: :country, in: location} }

            context 'with the :in option set to the country code' do
              let(:location) { 'US' }
              it { expect(result.keys).to eq ['US'] }
            end

            context 'with the :in option set to {country: country code}' do
              let(:location) { {country: 'US'} }
              it { expect(result.keys).to eq ['US'] }
            end
          end
        end
      end

      [:views, :annotation_clicks, :annotation_click_through_rate,
       :card_impressions, :card_clicks, :card_click_rate,
       :card_teaser_impressions, :card_teaser_clicks, :card_teaser_click_rate,
       :annotation_close_rate].each do |metric|
        describe "#{metric} can be retrieved for a single country" do
          let(:result) { video.public_send metric, options }

          context 'and grouped by state' do
            let(:options) { {by: :state, in: location} }

            context 'with the :in option set to the country code' do
              let(:location) { 'US' }
              it { expect(result.keys.map(&:length).uniq).to eq [2] }
            end

            context 'with the :in option set to {country: country code}' do
              let(:location) { {country: 'US'} }
              it { expect(result.keys.map(&:length).uniq).to eq [2] }
            end
          end
        end
      end

      describe 'multiple reports can be retrieved at once' do
        metrics = {views: Integer,
          estimated_minutes_watched: Integer, comments: Integer, likes: Integer,
          dislikes: Integer, shares: Integer, subscribers_gained: Integer,
          subscribers_lost: Integer,
          videos_added_to_playlists: Integer, videos_removed_from_playlists: Integer,
          average_view_duration: Integer,
          average_view_percentage: Float, annotation_clicks: Integer,
          card_impressions: Integer, card_clicks: Integer,
          card_click_rate: Float, card_teaser_impressions: Integer,
          card_teaser_clicks: Integer, card_teaser_click_rate: Float,
          annotation_click_through_rate: Float,
          annotation_close_rate: Float, estimated_revenue: Float, ad_impressions: Integer,
          monetized_playbacks: Integer}

        specify 'by day' do
          range = {since: 5.days.ago.to_date, until: 3.days.ago.to_date}
          result = video.reports range.merge(only: metrics, by: :day)
          metrics.each do |metric, type|
            expect(result[metric].keys).to all(be_a Date)
            expect(result[metric].values).to all(be_a type)
          end
        end

        specify 'by month' do
          result = video.reports only: metrics, by: :month, since: 1.month.ago
          metrics.each do |metric, type|
            expect(result[metric].keys).to all(be_a Range)
            expect(result[metric].keys.map &:first).to all(be_a Date)
            expect(result[metric].keys.map &:first).to eq result[metric].keys.map(&:first).map(&:beginning_of_month)
            expect(result[metric].keys.map &:last).to all(be_a Date)
            expect(result[metric].keys.map &:last).to eq result[metric].keys.map(&:last).map(&:end_of_month)
            expect(result[metric].values).to all(be_a type)
          end
        end

        specify 'by week' do
          range = {since: ENV['YT_TEST_PARTNER_VIDEO_DATE'], until: Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 9}
          result = video.reports range.merge(only: metrics, by: :week)
          metrics.each do |metric, type|
            expect(result[metric].size).to be <= 2
            expect(result[metric].keys).to all(be_a Range)
            expect(result[metric].keys.map{|range| range.first.wday}.uniq).to be_one
            expect(result[metric].keys.map{|range| range.last.wday}.uniq).to be_one
            expect(result[metric].values).to all(be_a type)
          end
        end
      end

      describe 'estimated_revenue can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          estimated_revenue = video.estimated_revenue range.merge by: :day
          expect(estimated_revenue.keys).to eq range.values
        end
      end

      describe 'estimated_revenue can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          estimated_revenue = video.estimated_revenue range.merge by: :country
          expect(estimated_revenue.keys).to all(be_a String)
          expect(estimated_revenue.keys.map(&:length).uniq).to eq [2]
          expect(estimated_revenue.values).to all(be_a Float)
        end
      end

      describe 'views can be retrieved for a single US state' do
        let(:state_code) { 'NY' }
        let(:views) { video.views since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(views.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(views.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by US state' do
          let(:by) { :state }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(views.keys).to eq [state_code] }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(views.keys).to eq [state_code] }
          end
        end
      end

      describe 'views can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

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

        specify 'and are returned sorted by descending views' do
          views = video.views range.merge by: :traffic_source
          expect(views.values.sort.reverse).to eq views.values
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
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :embedded_player_location' do
          views = video.views range.merge by: :embedded_player_location
          expect(views).not_to be_empty
        end
      end

      describe 'views can be grouped by related video' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :related_video' do
          views = video.views range.merge by: :related_video
          expect(views.keys).to all(be_instance_of Yt::Video)
        end
      end

      describe 'views can be grouped by search term' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :search_term' do
          views = video.views range.merge by: :search_term
          expect(views.keys).to all(be_a String)
        end
      end

      describe 'views can be grouped by referrer' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :referrer' do
          views = video.views range.merge by: :referrer
          expect(views.keys).to all(be_a String)
        end
      end

      describe 'views can be grouped by device type' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }
        let(:keys) { Yt::Collections::Reports::DEVICE_TYPES.keys }

        specify 'with the :by option set to :device_type' do
          views = video.views range.merge by: :device_type
          expect(views.keys - keys).to be_empty
          expect(views.values).to all(be_an Integer)
        end
      end

      describe 'views can be grouped by operating system' do
        let(:keys) { Yt::Collections::Reports::OPERATING_SYSTEMS.keys }

        specify 'with the :by option set to :operating_system' do
          views = video.views by: :operating_system
          expect(views.keys - keys).to be_empty
          expect(views.values).to all(be_an Integer)
        end
      end

      describe 'views can be grouped by YouTube product' do
        let(:keys) { Yt::Collections::Reports::YOUTUBE_PRODUCTS.keys }

        specify 'with the :by option set to :youtube_product' do
          views = video.views by: :youtube_product
          expect(views.keys - keys).to be_empty
          expect(views.values).to all(be_an Integer)
        end
      end

      describe 'views can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          views = video.views range.merge by: :country
          expect(views.keys).to all(be_a String)
          expect(views.keys.map(&:length).uniq).to eq [2]
          expect(views.values).to all(be_an Integer)
        end

        specify 'and are returned sorted by descending views' do
          views = video.views range.merge by: :country
          expect(views.values.sort.reverse).to eq views.values
        end
      end

      describe 'views can be grouped by state' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :state' do
          views = video.views range.merge by: :state
          expect(views.keys).to all(be_a String)
          expect(views.keys.map(&:length).uniq).to eq [2]
          expect(views.values).to all(be_an Integer)
        end

        specify 'and are returned sorted by descending views' do
          views = video.views range.merge by: :state
          expect(views.values.sort.reverse).to eq views.values
        end
      end

      describe 'views can be grouped by subscribed statuses' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }
        let(:keys) { Yt::Collections::Reports::SUBSCRIBED_STATUSES.keys }

        specify 'with the :by option set to subscribed statuses' do
          views = video.views range.merge by: :subscribed_status
          expect(views.keys - keys).to be_empty
          expect(views.values).to all(be_an Integer)
        end
      end

      describe 'comments can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          comments = video.comments range.merge by: :day
          expect(comments.keys).to eq range.values
        end
      end

      describe 'comments can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          comments = video.comments range.merge by: :country
          expect(comments.keys).to all(be_a String)
          expect(comments.keys.map(&:length).uniq).to eq [2]
          expect(comments.values).to all(be_an Integer)
        end
      end

      describe 'likes can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          likes = video.likes range.merge by: :day
          expect(likes.keys).to eq range.values
        end
      end

      describe 'likes can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          likes = video.likes range.merge by: :country
          expect(likes.keys).to all(be_a String)
          expect(likes.keys.map(&:length).uniq).to eq [2]
          expect(likes.values).to all(be_an Integer)
        end
      end

      describe 'dislikes can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          dislikes = video.dislikes range.merge by: :day
          expect(dislikes.keys).to eq range.values
        end
      end

      describe 'dislikes can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          dislikes = video.dislikes range.merge by: :country
          expect(dislikes.keys).to all(be_a String)
          expect(dislikes.keys.map(&:length).uniq).to eq [2]
          expect(dislikes.values).to all(be_an Integer)
        end
      end

      describe 'shares can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          shares = video.shares range.merge by: :day
          expect(shares.keys).to eq range.values
        end
      end

      describe 'shares can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          shares = video.shares range.merge by: :country
          expect(shares.keys).to all(be_a String)
          expect(shares.keys.map(&:length).uniq).to eq [2]
          expect(shares.values).to all(be_an Integer)
        end
      end

      describe 'gained subscribers can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          subscribers_gained = video.subscribers_gained range.merge by: :day
          expect(subscribers_gained.keys).to eq range.values
        end
      end

      describe 'gained subscribers can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          subscribers_gained = video.subscribers_gained range.merge by: :country
          expect(subscribers_gained.keys).to all(be_a String)
          expect(subscribers_gained.keys.map(&:length).uniq).to eq [2]
          expect(subscribers_gained.values).to all(be_an Integer)
        end
      end

      describe 'lost subscribers can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          subscribers_lost = video.subscribers_lost range.merge by: :day
          expect(subscribers_lost.keys).to eq range.values
        end
      end

      describe 'lost subscribers can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          subscribers_lost = video.subscribers_lost range.merge by: :country
          expect(subscribers_lost.keys).to all(be_a String)
          expect(subscribers_lost.keys.map(&:length).uniq).to eq [2]
          expect(subscribers_lost.values).to all(be_an Integer)
        end
      end

      describe 'added to playlists can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          videos_added_to_playlists = video.videos_added_to_playlists range.merge by: :day
          expect(videos_added_to_playlists.keys).to eq range.values
        end
      end

      describe 'added to playlists can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          videos_added_to_playlists = video.videos_added_to_playlists range.merge by: :country
          expect(videos_added_to_playlists.keys).to all(be_a String)
          expect(videos_added_to_playlists.keys.map(&:length).uniq).to eq [2]
          expect(videos_added_to_playlists.values).to all(be_an Integer)
        end
      end

      describe 'removed from playlists can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          videos_removed_from_playlists = video.videos_removed_from_playlists range.merge by: :day
          expect(videos_removed_from_playlists.keys).to eq range.values
        end
      end

      describe 'removed from playlists can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          videos_removed_from_playlists = video.videos_removed_from_playlists range.merge by: :country
          expect(videos_removed_from_playlists.keys).to all(be_a String)
          expect(videos_removed_from_playlists.keys.map(&:length).uniq).to eq [2]
          expect(videos_removed_from_playlists.values).to all(be_an Integer)
        end
      end

      describe 'estimated minutes watched can be retrieved for a single US state' do
        let(:state_code) { 'NY' }
        let(:minutes) { video.estimated_minutes_watched since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(minutes.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(minutes.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by US state' do
          let(:by) { :state }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(minutes.keys).to eq [state_code] }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(minutes.keys).to eq [state_code] }
          end
        end
      end

      describe 'estimated minutes watched can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

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

      describe 'estimated minutes watched can be grouped by playback location' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }
        let(:keys) { Yt::Collections::Reports::PLAYBACK_LOCATIONS.keys }

        specify 'with the :by option set to :playback_location' do
          estimated_minutes_watched = video.estimated_minutes_watched range.merge by: :playback_location
          expect(estimated_minutes_watched.keys - keys).to be_empty
        end
      end

      describe 'estimated minutes watched can be grouped by embedded player location' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :embedded_player_location' do
          estimated_minutes_watched = video.estimated_minutes_watched range.merge by: :embedded_player_location
          expect(estimated_minutes_watched).not_to be_empty
        end
      end

      describe 'estimated minutes watched can be grouped by related video' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :related_video' do
          estimated_minutes_watched = video.estimated_minutes_watched range.merge by: :related_video
          expect(estimated_minutes_watched.keys).to all(be_instance_of Yt::Video)
        end
      end

      describe 'estimated minutes watched can be grouped by search term' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :search_term' do
          estimated_minutes_watched = video.estimated_minutes_watched range.merge by: :search_term
          expect(estimated_minutes_watched.keys).to all(be_a String)
        end
      end

      describe 'estimated minutes watched can be grouped by referrer' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :referrer' do
          estimated_minutes_watched = video.estimated_minutes_watched range.merge by: :referrer
          expect(estimated_minutes_watched.keys).to all(be_a String)
        end
      end

      describe 'estimated minutes watched can be grouped by device type' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :device_type' do
          estimated_minutes_watched = video.estimated_minutes_watched range.merge by: :device_type
          expect(estimated_minutes_watched.keys).to all(be_instance_of Symbol)
          expect(estimated_minutes_watched.values).to all(be_an Integer)
        end
      end

      describe 'estimated minutes watched can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          minutes = video.estimated_minutes_watched range.merge by: :country
          expect(minutes.keys).to all(be_a String)
          expect(minutes.keys.map(&:length).uniq).to eq [2]
          expect(minutes.values).to all(be_an Integer)
        end
      end

      describe 'estimated minutes watched can be grouped by state' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :state' do
          minutes = video.estimated_minutes_watched range.merge by: :state
          expect(minutes.keys).to all(be_a String)
          expect(minutes.keys.map(&:length).uniq).to eq [2]
          expect(minutes.values).to all(be_an Integer)
        end
      end

      describe 'average view duration can be retrieved for a single US state' do
        let(:state_code) { 'NY' }
        let(:duration) { video.average_view_duration since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(duration.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(duration.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by US state' do
          let(:by) { :state }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(duration.keys).to eq [state_code] }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(duration.keys).to eq [state_code] }
          end
        end
      end

      describe 'average view duration can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          average_view_duration = video.average_view_duration range.merge by: :day
          expect(average_view_duration.keys).to eq range.values
        end
      end

      describe 'average view duration can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          duration = video.average_view_duration range.merge by: :country
          expect(duration.keys).to all(be_a String)
          expect(duration.keys.map(&:length).uniq).to eq [2]
          expect(duration.values).to all(be_an Integer)
        end
      end

      describe 'average view duration can be grouped by state' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :state' do
          duration = video.average_view_duration range.merge by: :state
          expect(duration.keys).to all(be_a String)
          expect(duration.keys.map(&:length).uniq).to eq [2]
          expect(duration.values).to all(be_an Integer)
        end
      end

      describe 'average view percentage can be retrieved for a single US state' do
        let(:state_code) { 'NY' }
        let(:percentage) { video.average_view_percentage since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(percentage.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(percentage.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by US state' do
          let(:by) { :state }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(percentage.keys).to eq [state_code] }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(percentage.keys).to eq [state_code] }
          end
        end
      end

      describe 'average view percentage can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          average_view_percentage = video.average_view_percentage range.merge by: :day
          expect(average_view_percentage.keys).to eq range.values
        end
      end

      describe 'average view percentage can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          percentage = video.average_view_percentage range.merge by: :country
          expect(percentage.keys).to all(be_a String)
          expect(percentage.keys.map(&:length).uniq).to eq [2]
          expect(percentage.values).to all(be_a Float)
        end
      end

      describe 'average view percentage can be grouped by state' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :state' do
          percentage = video.average_view_percentage range.merge by: :state
          expect(percentage.keys).to all(be_a String)
          expect(percentage.keys.map(&:length).uniq).to eq [2]
          expect(percentage.values).to all(be_a Float)
        end
      end

      describe 'ad_impressions can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          ad_impressions = video.ad_impressions range.merge by: :day
          expect(ad_impressions.keys).to eq range.values
        end
      end

      describe 'ad_impressions can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          ad_impressions = video.ad_impressions range.merge by: :country
          expect(ad_impressions.keys).to all(be_a String)
          expect(ad_impressions.keys.map(&:length).uniq).to eq [2]
          expect(ad_impressions.values).to all(be_an Integer)
        end
      end

      describe 'monetized_playbacks can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          monetized_playbacks = video.monetized_playbacks range.merge by: :day
          expect(monetized_playbacks.keys).to eq range.values
        end
      end

      describe 'monetized playbacks can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          playbacks = video.monetized_playbacks range.merge by: :country
          expect(playbacks.keys).to all(be_a String)
          expect(playbacks.keys.map(&:length).uniq).to eq [2]
          expect(playbacks.values).to all(be_an Integer)
        end
      end

      describe 'playback-based CPM can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          playback_based_cpm = video.playback_based_cpm range.merge by: :day
          expect(playback_based_cpm.keys).to eq range.values
        end
      end

      describe 'playback-based CPM can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          playbacks = video.playback_based_cpm range.merge by: :country
          expect(playbacks.keys).to all(be_a String)
          expect(playbacks.keys.map(&:length).uniq).to eq [2]
          expect(playbacks.values).to all(be_a Float)
        end
      end

      describe 'annotation clicks can be retrieved for a single US state' do
        let(:state_code) { 'CA' }
        let(:clicks) { video.annotation_clicks since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(clicks.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(clicks.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by US state' do
          let(:by) { :state }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(clicks.keys).to eq [state_code] }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(clicks.keys).to eq [state_code] }
          end
        end
      end

      describe 'annotation clicks can be grouped by day' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE'], until: Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 5} }

        specify 'with the :by option set to :day' do
          annotation_clicks = video.annotation_clicks range.merge by: :day
          expect(annotation_clicks.values).to all(be_an Integer)
        end
      end

      describe 'annotation clicks can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          clicks = video.annotation_clicks range.merge by: :country
          expect(clicks.keys).to all(be_a String)
          expect(clicks.keys.map(&:length).uniq).to eq [2]
          expect(clicks.values).to all(be_an Integer)
        end
      end

      describe 'annotation clicks can be grouped by state' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :state' do
          clicks = video.annotation_clicks range.merge by: :state
          expect(clicks.keys).to all(be_a String)
          expect(clicks.keys.map(&:length).uniq).to eq [2]
          expect(clicks.values).to all(be_an Integer)
        end
      end

      describe 'annotation click_through_rate can be retrieved for a single US state' do
        let(:state_code) { 'CA' }
        let(:click_through_rate) { video.annotation_click_through_rate since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(click_through_rate.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(click_through_rate.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by US state' do
          let(:by) { :state }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(click_through_rate.keys).to eq [state_code] }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(click_through_rate.keys).to eq [state_code] }
          end
        end
      end

      describe 'annotation click-through rate can be grouped by day' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE'], until: Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 5} }

        specify 'with the :by option set to :day' do
          annotation_click_through_rate = video.annotation_click_through_rate range.merge by: :day
          expect(annotation_click_through_rate.values).to all(be_instance_of Float)
        end
      end

      describe 'annotation click-through rate can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          rate = video.annotation_click_through_rate range.merge by: :country
          expect(rate.keys).to all(be_a String)
          expect(rate.keys.map(&:length).uniq).to eq [2]
          expect(rate.values).to all(be_a Float)
        end
      end

      describe 'annotation click-through rate can be grouped by state' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :state' do
          rate = video.annotation_click_through_rate range.merge by: :state
          expect(rate.keys).to all(be_a String)
          expect(rate.keys.map(&:length).uniq).to eq [2]
          expect(rate.values).to all(be_a Float)
        end
      end

      describe 'annotation close_rate can be retrieved for a single US state' do
        let(:state_code) { 'CA' }
        let(:close_rate) { video.annotation_close_rate since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(close_rate.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(close_rate.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by US state' do
          let(:by) { :state }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(close_rate.keys).to eq [state_code] }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(close_rate.keys).to eq [state_code] }
          end
        end
      end

      describe 'annotation close rate can be grouped by day' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE'], until: Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 5} }

        specify 'with the :by option set to :day' do
          annotation_close_rate = video.annotation_close_rate range.merge by: :day
          expect(annotation_close_rate.values).to all(be_instance_of Float)
        end
      end

      describe 'annotation close rate can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          rate = video.annotation_close_rate range.merge by: :country
          expect(rate.keys).to all(be_a String)
          expect(rate.keys.map(&:length).uniq).to eq [2]
          expect(rate.values).to all(be_a Float)
        end
      end

      describe 'annotation close rate can be grouped by state' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :state' do
          rate = video.annotation_close_rate range.merge by: :state
          expect(rate.keys).to all(be_a String)
          expect(rate.keys.map(&:length).uniq).to eq [2]
          expect(rate.values).to all(be_a Float)
        end
      end

      describe 'viewer percentage can be retrieved for a range of days' do
        let(:viewer_percentage) { video.viewer_percentage since: 1.year.ago, until: 10.days.ago}
        it { expect(viewer_percentage).to be_a Hash }
      end

      describe 'viewer_percentage can be grouped by gender and age group' do
        let(:range) { {since: 1.year.ago.to_date, until: 1.week.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          viewer_percentage = video.viewer_percentage range
          expect(viewer_percentage.keys).to match_array [:female, :male]
          expect(viewer_percentage[:female].keys - %w(65- 35-44 45-54 13-17 25-34 55-64 18-24)).to be_empty
          expect(viewer_percentage[:female].values).to all(be_instance_of Float)
          expect(viewer_percentage[:male].keys - %w(65- 35-44 45-54 13-17 25-34 55-64 18-24)).to be_empty
          expect(viewer_percentage[:male].values).to all(be_instance_of Float)
        end

        specify 'with the :by option set to :gender_age_group' do
          viewer_percentage = video.viewer_percentage range.merge by: :gender_age_group
          expect(viewer_percentage.keys).to match_array [:female, :male]
          expect(viewer_percentage[:female].keys - %w(65- 35-44 45-54 13-17 25-34 55-64 18-24)).to be_empty
          expect(viewer_percentage[:female].values).to all(be_instance_of Float)
          expect(viewer_percentage[:male].keys - %w(65- 35-44 45-54 13-17 25-34 55-64 18-24)).to be_empty
          expect(viewer_percentage[:male].values).to all(be_instance_of Float)
        end
      end

      describe 'viewer percentage can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:viewer_percentage) { video.viewer_percentage since: date, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'with the :in option set to the country code' do
          let(:location) { country_code }
          it { expect(viewer_percentage.keys).to match_array [:female, :male] }
        end

        context 'with the :in option set to {country: country code}' do
          let(:location) { {country: country_code} }
          it { expect(viewer_percentage.keys).to match_array [:female, :male] }
        end
      end

      describe 'viewer percentage can be retrieved for a single US state' do
        let(:state_code) { 'CA' }
        let(:viewer_percentage) { video.viewer_percentage since: date, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'with the :in option set to {state: state code}' do
          let(:location) { {state: state_code} }
          it { expect(viewer_percentage.keys).to match_array [:female, :male] }
        end

        context 'with the :in option set to {country: "US", state: state code}' do
          let(:location) { {country: 'US', state: state_code} }
          it { expect(viewer_percentage.keys).to match_array [:female, :male] }
        end
      end

      describe 'viewer percentage can be grouped by gender' do
        let(:range) { {since: 1.year.ago.to_date, until: 1.week.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :gender' do
          viewer_percentage = video.viewer_percentage range.merge by: :gender
          expect(viewer_percentage.keys).to match_array [:female, :male]
          expect(viewer_percentage[:female]).to be_a Float
          expect(viewer_percentage[:male]).to be_a Float
        end
      end

      describe 'viewer_percentage can be grouped by age group' do
        let(:range) { {since: 1.year.ago.to_date, until: 1.week.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :age_group' do
          viewer_percentage = video.viewer_percentage range.merge by: :age_group
          expect(viewer_percentage.keys - %w(65- 35-44 45-54 13-17 25-34 55-64 18-24)).to be_empty
          expect(viewer_percentage.values).to all(be_instance_of Float)
        end
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
