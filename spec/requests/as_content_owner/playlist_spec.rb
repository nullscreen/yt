# encoding: UTF-8
require 'spec_helper'
require 'yt/models/channel'
require 'yt/models/playlist'

describe Yt::Playlist, :partner do
  subject(:playlist) { Yt::Playlist.new id: id, auth: $content_owner }

  context 'given a playlist of a partnered channel', :partner do
    context 'managed by the authenticated Content Owner' do
      let(:id) { ENV['YT_TEST_PARTNER_PLAYLIST_ID'] }

      describe 'multiple reports can be retrieved at once' do
        metrics = {views: Integer, estimated_minutes_watched: Integer,
         average_view_duration: Integer, playlist_starts: Integer,
         average_time_in_playlist: Float, views_per_playlist_start: Float}

        specify 'by day' do
          range = {since: 5.days.ago.to_date, until: 3.days.ago.to_date}
          result = playlist.reports range.merge(only: metrics, by: :day)
          metrics.each do |metric, type|
            expect(result[metric].keys).to all(be_a Date)
            expect(result[metric].values).to all(be_a type)
          end
        end

        specify 'by month' do
          result = playlist.reports only: metrics, by: :month, since: 1.month.ago
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

      {views: Integer, estimated_minutes_watched: Integer,
       average_view_duration: Integer, playlist_starts: Integer,
       average_time_in_playlist: Float,
       views_per_playlist_start: Float}.each do |metric, type|
        describe "#{metric} can be retrieved for a range of days" do
          let(:date_in) { ENV['YT_TEST_PARTNER_VIDEO_DATE'] }
          let(:date_out) { Date.parse(ENV['YT_TEST_PARTNER_VIDEO_DATE']) + 5 }
          let(:metric) { metric }
          let(:result) { playlist.public_send metric, options }

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
          let(:result) { playlist.public_send metric, by: :month, since: 1.month.ago }
          specify do
            expect(result.keys).to all(be_a Range)
            expect(result.keys.map &:first).to all(be_a Date)
            expect(result.keys.map &:first).to eq result.keys.map(&:first).map(&:beginning_of_month)
            expect(result.keys.map &:last).to all(be_a Date)
            expect(result.keys.map &:last).to eq result.keys.map(&:last).map(&:end_of_month)
          end
        end

        describe "#{metric} can be grouped by range" do
          let(:metric) { metric }

          context 'without a :by option (default)' do
            let(:result) { playlist.public_send metric }
            specify do
              expect(result.size).to be 1
              expect(result[:total]).to be_a type
            end
          end

          context 'with the :by option set to :range' do
            let(:result) { playlist.public_send metric, by: :range }
            specify do
              expect(result.size).to be 1
              expect(result[:total]).to be_a type
            end
          end
        end

        describe "#{metric} can be retrieved for a single country" do
          let(:result) { playlist.public_send metric, options }

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

      describe 'views can be retrieved for a single US state' do
        let(:state_code) { 'CA' }
        let(:result) { playlist.views since: date, by: by, in: location }
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

      describe 'views can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          views = playlist.views range.merge by: :day
          expect(views.keys).to eq range.values
        end
      end

      describe 'views can be grouped by traffic source' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }
        let(:keys) { Yt::Collections::Reports::TRAFFIC_SOURCES.keys }

        specify 'with the :by option set to :traffic_source' do
          views = playlist.views range.merge by: :traffic_source
          expect(views.keys - keys).to be_empty
        end
      end

      describe 'views can be grouped by playback location' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }
        let(:keys) { Yt::Collections::Reports::PLAYBACK_LOCATIONS.keys }

        specify 'with the :by option set to :playback_location' do
          views = playlist.views range.merge by: :playback_location
          expect(views.keys - keys).to be_empty
        end
      end

      describe 'views can be grouped by related video' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :related_video' do
          views = playlist.views range.merge by: :related_video
          expect(views.keys).to all(be_instance_of Yt::Video)
        end
      end

      describe 'views can be grouped by search term' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_PLAYLIST_DATE']} }

        specify 'with the :by option set to :search_term' do
          views = playlist.views range.merge by: :search_term
          expect(views.keys).to all(be_a String)
        end
      end

      describe 'views can be grouped by referrer' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_PLAYLIST_DATE']} }

        specify 'with the :by option set to :referrer' do
          views = playlist.views range.merge by: :referrer
          expect(views.keys).to all(be_a String)
        end
      end

      describe 'views can be grouped by video' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :video' do
          views = playlist.views range.merge by: :video
          expect(views.keys).to all(be_instance_of Yt::Video)
        end
      end

      describe 'views can be grouped by playlist' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :playlist' do
          views = playlist.views range.merge by: :playlist
          expect(views.keys).to all(be_instance_of Yt::Playlist)
        end
      end

      describe 'views can be grouped by device type' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :device_type' do
          views = playlist.views range.merge by: :device_type
          expect(views.keys).to all(be_instance_of Symbol)
          expect(views.values).to all(be_an Integer)
        end
      end

      describe 'views can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          views = playlist.views range.merge by: :country
          expect(views.keys).to all(be_a String)
          expect(views.keys.map(&:length).uniq).to eq [2]
          expect(views.values).to all(be_an Integer)
        end
      end

      describe 'views can be grouped by state' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_PLAYLIST_DATE']} }

        specify 'with the :by option set to :state' do
          views = playlist.views range.merge by: :state
          expect(views.keys).to all(be_a String)
          expect(views.keys.map(&:length).uniq).to eq [2]
          expect(views.values).to all(be_an Integer)
        end
      end

      describe 'estimated minutes watched can be retrieved for a single US state' do
        let(:state_code) { 'CA' }
        let(:result) { playlist.estimated_minutes_watched since: date, by: by, in: location }
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

      describe 'estimated minutes watched can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          minutes = playlist.estimated_minutes_watched range.merge by: :day
          expect(minutes.keys).to eq range.values
        end
      end

      describe 'estimated minutes watched can be grouped by traffic source' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }
        let(:keys) { Yt::Collections::Reports::TRAFFIC_SOURCES.keys }

        specify 'with the :by option set to :traffic_source' do
          minutes = playlist.estimated_minutes_watched range.merge by: :traffic_source
          expect(minutes.keys - keys).to be_empty
        end
      end

      describe 'estimated minutes watched can be grouped by playback location' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }
        let(:keys) { Yt::Collections::Reports::PLAYBACK_LOCATIONS.keys }

        specify 'with the :by option set to :playback_location' do
          minutes = playlist.estimated_minutes_watched range.merge by: :playback_location
          expect(minutes.keys - keys).to be_empty
        end
      end

      describe 'estimated minutes watched can be grouped by related video' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :related_video' do
          minutes = playlist.estimated_minutes_watched range.merge by: :related_video
          expect(minutes.keys).to all(be_instance_of Yt::Video)
        end
      end

      describe 'estimated minutes watched can be grouped by search term' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_PLAYLIST_DATE']} }

        specify 'with the :by option set to :search_term' do
          minutes = playlist.estimated_minutes_watched range.merge by: :search_term
          expect(minutes.keys).to all(be_a String)
        end
      end

      describe 'estimated minutes watched can be grouped by referrer' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_PLAYLIST_DATE']} }

        specify 'with the :by option set to :referrer' do
          minutes = playlist.estimated_minutes_watched range.merge by: :referrer
          expect(minutes.keys).to all(be_a String)
        end
      end

      describe 'estimated minutes watched can be grouped by video' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :video' do
          minutes = playlist.estimated_minutes_watched range.merge by: :video
          expect(minutes.keys).to all(be_instance_of Yt::Video)
        end
      end

      describe 'estimated minutes watched can be grouped by playlist' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :playlist' do
          minutes = playlist.estimated_minutes_watched range.merge by: :playlist
          expect(minutes.keys).to all(be_instance_of Yt::Playlist)
        end
      end

      describe 'estimated minutes watched can be grouped by device type' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :device_type' do
          minutes = playlist.estimated_minutes_watched range.merge by: :device_type
          expect(minutes.keys).to all(be_instance_of Symbol)
          expect(minutes.values).to all(be_an Integer)
        end
      end

      describe 'estimated minutes watched can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          minutes = playlist.estimated_minutes_watched range.merge by: :country
          expect(minutes.keys).to all(be_a String)
          expect(minutes.keys.map(&:length).uniq).to eq [2]
          expect(minutes.values).to all(be_an Integer)
        end
      end

      describe 'estimated minutes watched can be grouped by state' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_PLAYLIST_DATE']} }

        specify 'with the :by option set to :state' do
          minutes = playlist.estimated_minutes_watched range.merge by: :state
          expect(minutes.keys).to all(be_a String)
          expect(minutes.keys.map(&:length).uniq).to eq [2]
          expect(minutes.values).to all(be_an Integer)
        end
      end

      describe 'viewer percentage can be retrieved for a range of days' do
        let(:viewer_percentage) { playlist.viewer_percentage since: 1.year.ago, until: 10.days.ago}
        it { expect(viewer_percentage).to be_a Hash }
      end

      describe 'viewer_percentage can be grouped by gender and age group' do
        let(:range) { {since: 1.year.ago.to_date, until: 1.week.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          viewer_percentage = playlist.viewer_percentage range
          expect(viewer_percentage.keys).to match_array [:female, :male]
          expect(viewer_percentage[:female].keys - %w(65- 35-44 45-54 13-17 25-34 55-64 18-24)).to be_empty
          expect(viewer_percentage[:female].values).to all(be_instance_of Float)
          expect(viewer_percentage[:male].keys - %w(65- 35-44 45-54 13-17 25-34 55-64 18-24)).to be_empty
          expect(viewer_percentage[:male].values).to all(be_instance_of Float)
        end

        specify 'with the :by option set to :gender_age_group' do
          viewer_percentage = playlist.viewer_percentage range.merge by: :gender_age_group
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
          viewer_percentage = playlist.viewer_percentage range.merge by: :gender
          expect(viewer_percentage.keys).to match_array [:female, :male]
          expect(viewer_percentage[:female]).to be_a Float
          expect(viewer_percentage[:male]).to be_a Float
        end
      end

      describe 'viewer_percentage can be grouped by age group' do
        let(:range) { {since: 1.year.ago.to_date, until: 1.week.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :age_group' do
          viewer_percentage = playlist.viewer_percentage range.merge by: :age_group
          expect(viewer_percentage.keys - %w(65- 35-44 45-54 13-17 25-34 55-64 18-24)).to be_empty
          expect(viewer_percentage.values).to all(be_instance_of Float)
        end
      end


      describe 'average view duration can be retrieved for a single US state' do
        let(:state_code) { 'CA' }
        let(:result) { playlist.average_view_duration since: date, by: by, in: location }
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

      describe 'average view duration can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          average_view_duration = playlist.average_view_duration range.merge by: :day
          expect(average_view_duration.keys).to eq range.values
        end
      end

      describe 'average view duration can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          duration = playlist.average_view_duration range.merge by: :country
          expect(duration.keys).to all(be_a String)
          expect(duration.keys.map(&:length).uniq).to eq [2]
          expect(duration.values).to all(be_an Integer)
        end
      end

      describe 'average view duration can be grouped by state' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_PLAYLIST_DATE']} }

        specify 'with the :by option set to :state' do
          duration = playlist.average_view_duration range.merge by: :state
          expect(duration.keys).to all(be_a String)
          expect(duration.keys.map(&:length).uniq).to eq [2]
          expect(duration.values).to all(be_an Integer)
        end
      end

      describe 'playlist starts can be retrieved for a single US state' do
        let(:state_code) { 'CA' }
        let(:result) { playlist.playlist_starts since: date, by: by, in: location }
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

      describe 'playlist starts can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          playlist_starts = playlist.playlist_starts range.merge by: :day
          expect(playlist_starts.keys).to eq range.values
        end
      end

      describe 'playlist starts can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_PLAYLIST_DATE']} }

        specify 'with the :by option set to :country' do
          starts = playlist.playlist_starts range.merge by: :country
          expect(starts.keys).to all(be_a String)
          expect(starts.keys.map(&:length).uniq).to eq [2]
          expect(starts.values).to all(be_an Integer)
        end
      end

      describe 'playlist starts can be grouped by state' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_PLAYLIST_DATE']} }

        specify 'with the :by option set to :state' do
          starts = playlist.playlist_starts range.merge by: :state
          expect(starts.keys).to all(be_a String)
          expect(starts.keys.map(&:length).uniq).to eq [2]
          expect(starts.values).to all(be_an Integer)
        end
      end

      describe 'average time in playlist can be retrieved for a single US state' do
        let(:state_code) { 'CA' }
        let(:result) { playlist.average_time_in_playlist since: date, by: by, in: location }
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

      describe 'average time in playlist can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          average_time_in_playlist = playlist.average_time_in_playlist range.merge by: :day
          expect(average_time_in_playlist.keys).to eq range.values
        end
      end

      describe 'average time in playlist can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_PLAYLIST_DATE']} }

        specify 'with the :by option set to :country' do
          time = playlist.average_time_in_playlist range.merge by: :country
          expect(time.keys).to all(be_a String)
          expect(time.keys.map(&:length).uniq).to eq [2]
          expect(time.values).to all(be_a Float)
        end
      end

      describe 'average time in playlist can be grouped by state' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_PLAYLIST_DATE']} }

        specify 'with the :by option set to :state' do
          time = playlist.average_time_in_playlist range.merge by: :state
          expect(time.keys).to all(be_a String)
          expect(time.keys.map(&:length).uniq).to eq [2]
          expect(time.values).to all(be_a Float)
        end
      end

      describe 'views per playlists start can be retrieved for a single US state' do
        let(:state_code) { 'CA' }
        let(:result) { playlist.views_per_playlist_start since: date, by: by, in: location }
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

      describe 'views per playlist start can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'with the :by option set to :day' do
          views_per_playlist_start = playlist.views_per_playlist_start range.merge by: :day
          expect(views_per_playlist_start.keys).to eq range.values
        end
      end

      describe 'views per playlist start can be grouped by country' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_PLAYLIST_DATE']} }

        specify 'with the :by option set to :country' do
          views = playlist.views_per_playlist_start range.merge by: :country
          expect(views.keys).to all(be_a String)
          expect(views.keys.map(&:length).uniq).to eq [2]
          expect(views.values).to all(be_a Float)
        end
      end

      describe 'views per playlist start can be grouped by state' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_PLAYLIST_DATE']} }

        specify 'with the :by option set to :state' do
          views = playlist.views_per_playlist_start range.merge by: :state
          expect(views.keys).to all(be_a String)
          expect(views.keys.map(&:length).uniq).to eq [2]
          expect(views.values).to all(be_a Float)
        end
      end
    end

    context 'not managed by the authenticated Content Owner' do
      let(:id) { 'PLbpi6ZahtOH6J5oPGySZcmbRfT7Hyq1sZ' }

      specify 'playlist starts cannot be retrieved' do
        expect{playlist.views}.to raise_error Yt::Errors::Forbidden
        expect{playlist.playlist_starts}.to raise_error Yt::Errors::Forbidden
        expect{playlist.average_time_in_playlist}.to raise_error Yt::Errors::Forbidden
        expect{playlist.views_per_playlist_start}.to raise_error Yt::Errors::Forbidden
      end
    end
  end
end
