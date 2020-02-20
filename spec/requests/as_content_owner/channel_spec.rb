# encoding: UTF-8
require 'spec_helper'
require 'yt/models/channel'
require 'yt/models/playlist'

describe Yt::Channel, :partner do
  subject(:channel) { Yt::Channel.new id: id, auth: $content_owner }

  context 'given a partnered channel', :partner do
    context 'managed by the authenticated Content Owner' do
      let(:id) { ENV['YT_TEST_PARTNER_CHANNEL_ID'] }

      describe 'multiple reports can be retrieved at once' do
        metrics = {views: Integer,
          estimated_minutes_watched: Integer, comments: Integer, likes: Integer,
          dislikes: Integer, shares: Integer, subscribers_gained: Integer,
          subscribers_lost: Integer,
          videos_added_to_playlists: Integer, videos_removed_from_playlists: Integer,
          average_view_duration: Integer,
          average_view_percentage: Float, annotation_clicks: Integer,
          annotation_click_through_rate: Float, annotation_close_rate: Float,
          card_impressions: Integer, card_clicks: Integer,
          card_click_rate: Float, card_teaser_impressions: Integer,
          card_teaser_clicks: Integer, card_teaser_click_rate: Float,
          estimated_revenue: Float, ad_impressions: Integer,
          monetized_playbacks: Integer, playback_based_cpm: Float}
        specify 'by day, and are chronologically sorted' do
          range = {since: 5.days.ago.to_date, until: 3.days.ago.to_date}
          result = channel.reports range.merge(only: metrics, by: :day)
          metrics.each do |metric, type|
            expect(result[metric].keys).to all(be_a Date)
            expect(result[metric].values).to all(be_a type)
            expect(result[metric].keys.sort).to eq result[metric].keys
          end
        end

        specify 'by month, and are chronologically sorted' do
          result = channel.reports only: metrics, by: :month, since: 1.month.ago
          metrics.each do |metric, type|
            expect(result[metric].keys).to all(be_a Range)
            expect(result[metric].keys.map &:first).to all(be_a Date)
            expect(result[metric].keys.map &:first).to eq result[metric].keys.map(&:first).map(&:beginning_of_month)
            expect(result[metric].keys.map &:last).to all(be_a Date)
            expect(result[metric].keys.map &:last).to eq result[metric].keys.map(&:last).map(&:end_of_month)
            expect(result[metric].values).to all(be_a type)
          end
        end
      end

      [:views, :comments, :likes, :dislikes, :shares,
       :subscribers_gained, :subscribers_lost,
       :videos_added_to_playlists, :videos_removed_from_playlists,
       :estimated_minutes_watched, :average_view_duration,
       :average_view_percentage, :ad_impressions, :monetized_playbacks,
       :annotation_clicks, :annotation_click_through_rate,
       :card_impressions, :card_clicks, :card_click_rate,
       :card_teaser_impressions, :card_teaser_clicks, :card_teaser_click_rate,
       :playback_based_cpm, :annotation_close_rate, :estimated_revenue].each do |metric|
        describe "#{metric} can be retrieved for a range of days" do
          let(:date_in) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }
          let(:date_out) { Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 5 }
          let(:metric) { metric }
          let(:result) { channel.public_send metric, options }

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

          let(:result) { channel.public_send metric, by: :month, since: 3.months.ago }
          specify do
            expect(result.keys).to eq(result.keys.sort_by{|range| range.first})
            expect(result.keys).to all(be_a Range)
            expect(result.keys.map &:first).to all(be_a Date)
            expect(result.keys.map &:first).to eq result.keys.map(&:first).map(&:beginning_of_month)
            expect(result.keys.map &:last).to all(be_a Date)
            expect(result.keys.map &:last).to eq result.keys.map(&:last).map(&:end_of_month)
          end
        end
      end

      {views: Integer, comments: Integer, likes: Integer, dislikes: Integer,
       subscribers_gained: Integer, subscribers_lost: Integer,
       estimated_minutes_watched: Integer, average_view_duration: Integer,
       annotation_clicks: Integer, annotation_click_through_rate: Float,
       card_impressions: Integer, card_clicks: Integer,
       card_click_rate: Float, card_teaser_impressions: Integer,
       card_teaser_clicks: Integer, card_teaser_click_rate: Float,
       videos_added_to_playlists: Integer, videos_removed_from_playlists: Integer,
       average_view_percentage: Float, ad_impressions: Integer,
       shares: Integer, playback_based_cpm: Float,
       monetized_playbacks: Integer, annotation_close_rate: Float,
       estimated_revenue: Float}.each do |metric, type|
        describe "#{metric} can be grouped by range" do
          let(:metric) { metric }

          context 'without a :by option (default)' do
            let(:result) { channel.public_send metric }
            specify do
              expect(result.size).to be 1
              expect(result[:total]).to be_a type
            end
          end

          context 'with the :by option set to :range' do
            let(:result) { channel.public_send metric, by: :range }
            specify do
              expect(result.size).to be 1
              expect(result[:total]).to be_a type
            end
          end
        end
      end

      describe 'estimated_revenue can be retrieved for a specific day' do
        # NOTE: This test sounds redundant, but it’s actually a reflection of
        # another irrational behavior of YouTube API. In short, if you ask for
        # the "estimated_revenue" metric of a day in which a channel made 0 USD, then
        # the API returns "nil". But if you also for the "estimated_revenue" metric AND
        # the "estimatedMinutesWatched" metric, then the API returns the
        # correct value of "0", while still returning nil for those days in
        # which the estimated_revenue have not been estimated yet.
        context 'in which the channel did not make any money' do
          let(:zero_date) { ENV['YT_TEST_PARTNER_CHANNEL_NO_estimated_revenue_DATE'] }
          let(:estimated_revenue) { channel.estimated_revenue_on zero_date}
          it { expect(estimated_revenue).to eq 0 }
        end
      end

      describe 'estimated_revenue can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:estimated_revenue) { channel.estimated_revenue since: date, by: by, in: location }
        let(:date) { 4.days.ago }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(estimated_revenue.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(estimated_revenue.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(estimated_revenue.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(estimated_revenue.keys).to eq [country_code] }
          end
        end
      end

      describe 'estimated_revenue can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          estimated_revenue = channel.estimated_revenue range.merge by: :day
          expect(estimated_revenue.keys).to eq range.values
        end
      end

      describe 'estimated_revenue can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          estimated_revenue = channel.estimated_revenue range.merge by: :country
          expect(estimated_revenue.keys).to all(be_a String)
          expect(estimated_revenue.keys.map(&:length).uniq).to eq [2]
          expect(estimated_revenue.values).to all(be_a Float)
        end
      end

      describe 'views can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:views) { channel.views since: date, by: by, in: location }
        let(:date) { 4.days.ago }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(views.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(views.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(views.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(views.keys).to eq [country_code] }
          end
        end

        context 'and grouped by state' do
          let(:by) { :state }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(views.keys.map(&:length).uniq).to eq [2] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(views.keys.map(&:length).uniq).to eq [2] }
          end
        end
      end

      describe 'views can be retrieved for a single US state' do
        let(:state_code) { 'NY' }
        let(:result) { channel.views since: date, by: by, in: location }
        let(:date) { 4.days.ago }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(result.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(result.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by US state' do
          let(:by) { :state }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(result.keys).to eq [state_code] }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(result.keys).to eq [state_code] }
          end
        end
      end

      describe 'views can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          views = channel.views range.merge by: :day
          expect(views.keys).to eq range.values
        end

        specify 'and are returned chronologically sorted' do
          views = channel.views range.merge by: :day
          expect(views.keys.sort).to eq views.keys
        end
      end

      describe 'views can be grouped by traffic source' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }
        let(:keys) { Yt::Collections::Reports::TRAFFIC_SOURCES.keys }

        specify 'with the :by option set to :traffic_source' do
          views = channel.views range.merge by: :traffic_source
          expect(views.keys - keys).to be_empty
        end

        specify 'and are returned sorted by descending views' do
          views = channel.views range.merge by: :traffic_source
          expect(views.values.sort.reverse).to eq views.values
        end
      end

      describe 'views can be grouped by playback location' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }
        let(:keys) { Yt::Collections::Reports::PLAYBACK_LOCATIONS.keys }

        specify 'with the :by option set to :playback_location' do
          views = channel.views range.merge by: :playback_location
          expect(views.keys - keys).to be_empty
        end

        specify 'and are returned sorted by descending views' do
          views = channel.views range.merge by: :playback_location
          expect(views.values.sort.reverse).to eq views.values
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

        specify 'and provided with an :includes option to preload parts' do
          views = channel.views range.merge by: :related_video, includes: [:statistics]
          expect(views.keys.map{|v| v.instance_variable_defined? :@status}).to all(be false)
          expect(views.keys.map{|v| v.instance_variable_defined? :@statistics_set}).to all(be true)
        end
      end

      describe 'views can be grouped by search term' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :search_term' do
          views = channel.views range.merge by: :search_term
          expect(views.keys).to all(be_a String)
        end
      end

      describe 'views can be grouped by referrer' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :referrer' do
          views = channel.views range.merge by: :referrer
          expect(views.keys).to all(be_a String)
        end
      end

      describe 'views can be grouped by video' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :video' do
          views = channel.views range.merge by: :video
          expect(views.keys).to all(be_instance_of Yt::Video)
        end

        specify 'and provided with an :includes option to preload parts' do
          views = channel.views range.merge by: :video, includes: [:statistics]
          expect(views.keys.map{|v| v.instance_variable_defined? :@status}).to all(be false)
          expect(views.keys.map{|v| v.instance_variable_defined? :@statistics_set}).to all(be true)
        end
      end

      describe 'views can be grouped by playlist' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :playlist' do
          views = channel.views range.merge by: :playlist
          expect(views.keys).to all(be_instance_of Yt::Playlist)
        end

        specify 'and provided with an :includes option to preload parts' do
          views = channel.views range.merge by: :playlist, includes: [:status]
          expect(views.keys.map{|playlist| playlist.instance_variable_defined? :@content_details}).to all(be false)
          expect(views.keys.map{|playlist| playlist.instance_variable_defined? :@status}).to all(be true)
        end
      end

      describe 'views can be grouped by device type' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :device_type' do
          views = channel.views range.merge by: :device_type
          expect(views.keys).to all(be_instance_of Symbol)
          expect(views.values).to all(be_an Integer)
        end

        specify 'and are returned sorted by descending views' do
          views = channel.views range.merge by: :device_type
          expect(views.values.sort.reverse).to eq views.values
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

        specify 'and are returned sorted by descending views' do
          views = channel.views range.merge by: :country
          expect(views.values.sort.reverse).to eq views.values
        end
      end

      describe 'views can be grouped by state' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :state' do
          views = channel.views range.merge by: :state
          expect(views.keys).to all(be_a String)
          expect(views.keys.map(&:length).uniq).to eq [2]
          expect(views.values).to all(be_an Integer)
        end

        specify 'and are returned sorted by descending views' do
          views = channel.views range.merge by: :state
          expect(views.values.sort.reverse).to eq views.values
        end
      end

      describe 'views can be limited to a subset of videos' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }
        let(:videos) { channel.videos.first(2) }
        let(:video_views) { videos.inject(0){|total, video| total + video.views(range)[:total]} }

        specify 'with the :videos option listing the video IDs' do
          views = channel.views range.merge videos: videos.map(&:id)
          expect(views[:total]).to eq video_views
        end

        specify 'with a maximum of 200 video IDs' do
          views = channel.views range.merge videos: (videos*100).map(&:id)
          expect(views[:total]).to eq video_views
        end

        specify 'but fails with more than 200 video IDs' do
          expect{channel.views range.merge videos: (videos*101).map(&:id)}.to raise_error Yt::Errors::RequestError
        end
      end

      describe 'comments can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:comments) { channel.comments since: date, by: by, in: location }
        let(:date) { 4.days.ago }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(comments.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(comments.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(comments.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(comments.keys).to eq [country_code] }
          end
        end
      end

      describe 'comments can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

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

      describe 'likes can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:likes) { channel.likes since: date, by: by, in: location }
        let(:date) { 4.days.ago }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(likes.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(likes.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(likes.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(likes.keys).to eq [country_code] }
          end
        end
      end

      describe 'likes can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

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

      describe 'dislikes can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:dislikes) { channel.dislikes since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(dislikes.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(dislikes.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(dislikes.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(dislikes.keys).to eq [country_code] }
          end
        end
      end

      describe 'dislikes can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

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

      describe 'shares can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:shares) { channel.shares since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(shares.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(shares.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(shares.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(shares.keys).to eq [country_code] }
          end
        end
      end

      describe 'shares can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          shares = channel.shares range.merge by: :day
          expect(shares.keys).to eq range.values
        end
      end

      describe 'shares can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          shares = channel.shares range.merge by: :country
          expect(shares.keys).to all(be_a String)
          expect(shares.keys.map(&:length).uniq).to eq [2]
          expect(shares.values).to all(be_an Integer)
        end
      end

      describe 'gained subscribers can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:subscribers_gained) { channel.subscribers_gained since: date, by: by, in: location }
        let(:date) { 4.days.ago }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(subscribers_gained.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(subscribers_gained.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(subscribers_gained.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(subscribers_gained.keys).to eq [country_code] }
          end
        end
      end

      describe 'gained subscribers can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

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

      describe 'lost subscribers can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:subscribers_lost) { channel.subscribers_lost since: date, by: by, in: location }
        let(:date) { 4.days.ago }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(subscribers_lost.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(subscribers_lost.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(subscribers_lost.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(subscribers_lost.keys).to eq [country_code] }
          end
        end
      end

      describe 'lost subscribers can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

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

      describe 'videos added to playlists can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:videos_added_to_playlists) { channel.videos_added_to_playlists since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(videos_added_to_playlists.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(videos_added_to_playlists.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(videos_added_to_playlists.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(videos_added_to_playlists.keys).to eq [country_code] }
          end
        end
      end

      describe 'videos removed from playlists can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:videos_removed_from_playlists) { channel.videos_removed_from_playlists since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(videos_removed_from_playlists.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(videos_removed_from_playlists.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(videos_removed_from_playlists.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(videos_removed_from_playlists.keys).to eq [country_code] }
          end
        end
      end

      describe 'estimated minutes watched can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:estimated_minutes_watched) { channel.estimated_minutes_watched since: date, by: by, in: location }
        let(:date) { 4.days.ago }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(estimated_minutes_watched.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(estimated_minutes_watched.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(estimated_minutes_watched.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(estimated_minutes_watched.keys).to eq [country_code] }
          end
        end
      end

      describe 'estimated minutes watched can be retrieved for a single US state' do
        let(:state_code) { 'NY' }
        let(:result) { channel.estimated_minutes_watched since: date, by: by, in: location }
        let(:date) { 4.days.ago }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(result.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(result.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by US state' do
          let(:by) { :state }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(result.keys).to eq [state_code] }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(result.keys).to eq [state_code] }
          end
        end
      end

      describe 'estimated minutes watched can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

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

      describe 'estimated minutes watched can be grouped by search term' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :search_term' do
          estimated_minutes_watched = channel.estimated_minutes_watched range.merge by: :search_term
          expect(estimated_minutes_watched.keys).to all(be_a String)
        end
      end

      describe 'estimated minutes watched can be grouped by referrer' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :referrer' do
          estimated_minutes_watched = channel.estimated_minutes_watched range.merge by: :referrer
          expect(estimated_minutes_watched.keys).to all(be_a String)
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
          expect(estimated_minutes_watched.values).to all(be_an Integer)
        end
      end

      describe 'estimated minutes watched can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          minutes = channel.estimated_minutes_watched range.merge by: :country
          expect(minutes.keys).to all(be_a String)
          expect(minutes.keys.map(&:length).uniq).to eq [2]
          expect(minutes.values).to all(be_an Integer)
        end
      end

      describe 'estimated minutes watched can be grouped by state' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :state' do
          minutes = channel.estimated_minutes_watched range.merge by: :state
          expect(minutes.keys).to all(be_a String)
          expect(minutes.keys.map(&:length).uniq).to eq [2]
          expect(minutes.values).to all(be_an Integer)
        end
      end

      describe 'average view duration can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:average_view_duration) { channel.average_view_duration since: date, by: by, in: location }
        let(:date) { 4.days.ago }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(average_view_duration.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(average_view_duration.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(average_view_duration.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(average_view_duration.keys).to eq [country_code] }
          end
        end
      end

      describe 'average view duration can be retrieved for a single US state' do
        let(:state_code) { 'NY' }
        let(:result) { channel.average_view_duration since: date, by: by, in: location }
        let(:date) { 4.days.ago }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(result.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(result.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by US state' do
          let(:by) { :state }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(result.keys).to eq [state_code] }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(result.keys).to eq [state_code] }
          end
        end
      end

      describe 'average view duration can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

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
          expect(duration.values).to all(be_an Integer)
        end
      end

      describe 'average view duration can be grouped by state' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :state' do
          duration = channel.average_view_duration range.merge by: :state
          expect(duration.keys).to all(be_a String)
          expect(duration.keys.map(&:length).uniq).to eq [2]
          expect(duration.values).to all(be_an Integer)
        end
      end

      describe 'average view percentage can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:average_view_percentage) { channel.average_view_percentage since: date, by: by, in: location }
        let(:date) { 4.days.ago }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(average_view_percentage.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(average_view_percentage.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(average_view_percentage.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(average_view_percentage.keys).to eq [country_code] }
          end
        end
      end

      describe 'average view percentage can be retrieved for a single US state' do
        let(:state_code) { 'NY' }
        let(:result) { channel.average_view_percentage since: date, by: by, in: location }
        let(:date) { 4.days.ago }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(result.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(result.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by US state' do
          let(:by) { :state }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(result.keys).to eq [state_code] }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(result.keys).to eq [state_code] }
          end
        end
      end

      describe 'average view percentage can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

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

      describe 'average view percentage can be grouped by state' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :state' do
          percentage = channel.average_view_percentage range.merge by: :state
          expect(percentage.keys).to all(be_a String)
          expect(percentage.keys.map(&:length).uniq).to eq [2]
          expect(percentage.values).to all(be_a Float)
        end
      end

      describe 'ad_impressions can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:ad_impressions) { channel.ad_impressions since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_PLAYLIST_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(ad_impressions.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(ad_impressions.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(ad_impressions.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(ad_impressions.keys).to eq [country_code] }
          end
        end
      end

      describe 'ad_impressions can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          ad_impressions = channel.ad_impressions range.merge by: :day
          expect(ad_impressions.keys).to eq range.values
        end
      end

      describe 'ad_impressions can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_PLAYLIST_DATE']} }

        specify 'with the :by option set to :country' do
          ad_impressions = channel.ad_impressions range.merge by: :country
          expect(ad_impressions.keys).to all(be_a String)
          expect(ad_impressions.keys.map(&:length).uniq).to eq [2]
          expect(ad_impressions.values).to all(be_an Integer)
        end
      end

      describe 'monetized playbacks can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:monetized_playbacks) { channel.monetized_playbacks since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(monetized_playbacks.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(monetized_playbacks.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(monetized_playbacks.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(monetized_playbacks.keys).to eq [country_code] }
          end
        end
      end

      describe 'monetized_playbacks can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          monetized_playbacks = channel.monetized_playbacks range.merge by: :day
          expect(monetized_playbacks.keys).to eq range.values
        end
      end

      describe 'monetized playbacks can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_PLAYLIST_DATE']} }

        specify 'with the :by option set to :country' do
          playbacks = channel.monetized_playbacks range.merge by: :country
          expect(playbacks.keys).to all(be_a String)
          expect(playbacks.keys.map(&:length).uniq).to eq [2]
          expect(playbacks.values).to all(be_an Integer)
        end
      end

      describe 'playback-based CPM can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:playback_based_cpm) { channel.playback_based_cpm since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(playback_based_cpm.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(playback_based_cpm.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(playback_based_cpm.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(playback_based_cpm.keys).to eq [country_code] }
          end
        end
      end

      describe 'playback-based CPM can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          playback_based_cpm = channel.playback_based_cpm range.merge by: :day
          expect(playback_based_cpm.keys).to eq range.values
        end
      end

      describe 'playback-based CPM can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_PLAYLIST_DATE']} }

        specify 'with the :by option set to :country' do
          playbacks = channel.playback_based_cpm range.merge by: :country
          expect(playbacks.keys).to all(be_a String)
          expect(playbacks.keys.map(&:length).uniq).to eq [2]
          expect(playbacks.values).to all(be_a Float)
        end
      end

      describe 'annotation clicks can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:annotation_clicks) { channel.annotation_clicks since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(annotation_clicks.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(annotation_clicks.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(annotation_clicks.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(annotation_clicks.keys).to eq [country_code] }
          end
        end
      end

      describe 'annotation clicks can be retrieved for a single US state' do
        let(:state_code) { 'NY' }
        let(:result) { channel.annotation_clicks since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(result.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(result.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by US state' do
          let(:by) { :state }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(result.keys).to eq [state_code] }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(result.keys).to eq [state_code] }
          end
        end
      end

      describe 'annotation clicks can be grouped by day' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE'], until: Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 5} }

        specify 'with the :by option set to :day' do
          annotation_clicks = channel.annotation_clicks range.merge by: :day
          expect(annotation_clicks.values).to all(be_an Integer)
        end
      end

      describe 'annotation clicks can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          clicks = channel.annotation_clicks range.merge by: :country
          expect(clicks.keys).to all(be_a String)
          expect(clicks.keys.map(&:length).uniq).to eq [2]
          expect(clicks.values).to all(be_an Integer)
        end
      end

      describe 'annotation clicks can be grouped by state' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :state' do
          clicks = channel.annotation_clicks range.merge by: :state
          expect(clicks.keys).to all(be_a String)
          expect(clicks.keys.map(&:length).uniq).to eq [2]
          expect(clicks.values).to all(be_an Integer)
        end
      end

      describe 'annotation click-through rate can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:annotation_click_through_rate) { channel.annotation_click_through_rate since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(annotation_click_through_rate.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(annotation_click_through_rate.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(annotation_click_through_rate.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(annotation_click_through_rate.keys).to eq [country_code] }
          end
        end
      end

      describe 'annotation click-through rate can be retrieved for a single US state' do
        let(:state_code) { 'NY' }
        let(:result) { channel.annotation_click_through_rate since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(result.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(result.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by US state' do
          let(:by) { :state }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(result.keys).to eq [state_code] }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(result.keys).to eq [state_code] }
          end
        end
      end

      describe 'annotation click-through rate can be grouped by day' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE'], until: Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 5} }

        specify 'with the :by option set to :day' do
          annotation_click_through_rate = channel.annotation_click_through_rate range.merge by: :day
          expect(annotation_click_through_rate.values).to all(be_instance_of Float)
        end
      end

      describe 'annotation click-through rate can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :country' do
          rate = channel.annotation_click_through_rate range.merge by: :country
          expect(rate.keys).to all(be_a String)
          expect(rate.keys.map(&:length).uniq).to eq [2]
          expect(rate.values).to all(be_a Float)
        end
      end

      describe 'annotation click-through rate can be grouped by state' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :state' do
          rate = channel.annotation_click_through_rate range.merge by: :state
          expect(rate.keys).to all(be_a String)
          expect(rate.keys.map(&:length).uniq).to eq [2]
          expect(rate.values).to all(be_a Float)
        end
      end

      describe 'annotation close rate can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:annotation_close_rate) { channel.annotation_close_rate since: date, by: by, in: location }
        let(:date) { 4.days.ago }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(annotation_close_rate.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(annotation_close_rate.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by country' do
          let(:by) { :country }

          context 'with the :in option set to the country code' do
            let(:location) { country_code }
            it { expect(annotation_close_rate.keys).to eq [country_code] }
          end

          context 'with the :in option set to {country: country code}' do
            let(:location) { {country: country_code} }
            it { expect(annotation_close_rate.keys).to eq [country_code] }
          end
        end
      end

      describe 'annotation close rate can be retrieved for a single US state' do
        let(:state_code) { 'NY' }
        let(:result) { channel.annotation_close_rate since: date, by: by, in: location }
        let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

        context 'and grouped by day' do
          let(:by) { :day }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(result.keys.min).to eq date.to_date }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(result.keys.min).to eq date.to_date }
          end
        end

        context 'and grouped by US state' do
          let(:by) { :state }

          context 'with the :in option set to {state: state code}' do
            let(:location) { {state: state_code} }
            it { expect(result.keys).to eq [state_code] }
          end

          context 'with the :in option set to {country: "US", state: state code}' do
            let(:location) { {country: 'US', state: state_code} }
            it { expect(result.keys).to eq [state_code] }
          end
        end
      end

      describe 'annotation close rate can be grouped by day' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE'], until: Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 5} }

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

      describe 'annotation close rate can be grouped by state' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :state' do
          rate = channel.annotation_close_rate range.merge by: :state
          expect(rate.keys).to all(be_a String)
          expect(rate.keys.map(&:length).uniq).to eq [2]
          expect(rate.values).to all(be_a Float)
        end
      end

      describe 'viewer percentage can be retrieved for a single country' do
        let(:country_code) { 'US' }
        let(:viewer_percentage) { channel.viewer_percentage in: location }

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
         let(:state_code) { 'TX' }
         let(:viewer_percentage) { channel.viewer_percentage since: date, in: location }
         let(:date) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }

         context 'with the :in option set to {state: state code}' do
           let(:location) { {state: state_code} }
           it {expect(viewer_percentage.keys).to match_array [:female, :male] }
         end

         context 'with the :in option set to {country: "US", state: state code}' do
           let(:location) { {country: 'US', state: state_code} }
           it { expect(viewer_percentage.keys).to match_array [:female, :male] }
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

      specify 'estimated_revenue and ad_impressions cannot be retrieved' do
        expect{channel.estimated_revenue}.to raise_error Yt::Errors::Forbidden
        expect{channel.views}.to raise_error Yt::Errors::Forbidden
      end

      specify 'information about its content owner cannot be retrieved' do
        expect(channel.content_owner).to be_nil
        expect(channel.linked_at).to be_nil
      end
    end
  end
end
