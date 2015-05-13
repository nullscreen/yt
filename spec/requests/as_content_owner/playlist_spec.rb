# encoding: UTF-8
require 'spec_helper'
require 'yt/models/channel'
require 'yt/models/playlist'

describe Yt::Playlist, :partner do
  subject(:playlist) { Yt::Playlist.new id: id, auth: $content_owner }

  context 'given a playlist of a partnered channel', :partner do
    context 'managed by the authenticated Content Owner' do
      let(:id) { ENV['YT_TEST_PARTNER_PLAYLIST_ID'] }

      describe 'views can be retrieved for a specific day' do
        context 'in which the playlist was viewed' do
          let(:views) { playlist.views_on ENV['YT_TEST_PARTNER_PLAYLIST_DATE']}
          it { expect(views).to be_an Integer }
        end

        context 'in which the playlist was not viewed' do
          let(:views) { playlist.views_on 20.years.ago}
          it { expect(views).to be_nil }
        end
      end

      describe 'views can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(playlist.views(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(playlist.views(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(playlist.views(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(playlist.views(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'views can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          views = playlist.views range.merge by: :range
          expect(views.size).to be 1
          expect(views[:total]).to be_an Integer
        end
      end

      describe 'views can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          views = playlist.views range
          expect(views.keys).to eq range.values
        end

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

      describe 'estimated minutes watched can be retrieved for a specific day' do
        context 'in which the playlist was viewed' do
          let(:minutes) { playlist.estimated_minutes_watched_on ENV['YT_TEST_PARTNER_PLAYLIST_DATE']}
          it { expect(minutes).to be_a Float }
        end

        context 'in which the playlist was not viewed' do
          let(:minutes) { playlist.estimated_minutes_watched_on 20.years.ago}
          it { expect(minutes).to be_nil }
        end
      end

      describe 'estimated minutes watched can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(playlist.estimated_minutes_watched(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(playlist.estimated_minutes_watched(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(playlist.estimated_minutes_watched(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(playlist.estimated_minutes_watched(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'estimated minutes watched can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          minutes = playlist.estimated_minutes_watched range.merge by: :range
          expect(minutes.size).to be 1
          expect(minutes[:total]).to be_a Float
        end
      end

      describe 'estimated minutes watched can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          minutes = playlist.estimated_minutes_watched range
          expect(minutes.keys).to eq range.values
        end

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
          expect(minutes.values).to all(be_instance_of Float)
        end
      end

      describe 'estimated minutes watched can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          minutes = playlist.estimated_minutes_watched range.merge by: :country
          expect(minutes.keys).to all(be_a String)
          expect(minutes.keys.map(&:length).uniq).to eq [2]
          expect(minutes.values).to all(be_a Float)
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

      describe 'average view duration can be retrieved for a specific day' do
        context 'in which the playlist was partnered' do
          let(:average_view_duration) { playlist.average_view_duration_on ENV['YT_TEST_PARTNER_PLAYLIST_DATE']}
          it { expect(average_view_duration).to be_a Float }
        end

        context 'in which the playlist was not partnered' do
          let(:average_view_duration) { playlist.average_view_duration_on 20.years.ago}
          it { expect(average_view_duration).to be_nil }
        end
      end

      describe 'average view duration can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(playlist.average_view_duration(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(playlist.average_view_duration(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(playlist.average_view_duration(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(playlist.average_view_duration(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'average view duration can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          duration = playlist.average_view_duration range.merge by: :range
          expect(duration.size).to be 1
          expect(duration[:total]).to be_a Float
        end
      end

      describe 'average view duration can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          average_view_duration = playlist.average_view_duration range
          expect(average_view_duration.keys).to eq range.values
        end

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
          expect(duration.values).to all(be_a Float)
        end
      end

      describe 'playlist starts can be retrieved for a specific day' do
        context 'in which the playlist was viewed' do
          let(:playlist_starts) { playlist.playlist_starts_on ENV['YT_TEST_PARTNER_PLAYLIST_DATE']}
          it { expect(playlist_starts).to be_an Integer }
        end

        context 'in which the playlist was not viewed' do
          let(:playlist_starts) { playlist.playlist_starts_on 20.years.ago}
          it { expect(playlist_starts).to be_nil }
        end
      end

      describe 'playlist starts can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(playlist.playlist_starts(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(playlist.playlist_starts(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(playlist.playlist_starts(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(playlist.playlist_starts(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'playlist starts can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          playlist_starts = playlist.playlist_starts range.merge by: :range
          expect(playlist_starts.size).to be 1
          expect(playlist_starts[:total]).to be_an Integer
        end
      end

      describe 'playlist starts can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          playlist_starts = playlist.playlist_starts range
          expect(playlist_starts.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          playlist_starts = playlist.playlist_starts range.merge by: :day
          expect(playlist_starts.keys).to eq range.values
        end
      end

      describe 'average view duration can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          starts = playlist.playlist_starts range.merge by: :country
          expect(starts.keys).to all(be_a String)
          expect(starts.keys.map(&:length).uniq).to eq [2]
          expect(starts.values).to all(be_an Integer)
        end
      end

      describe 'average time in playlist can be retrieved for a specific day' do
        context 'in which the playlist was viewed' do
          let(:average_time_in_playlist) { playlist.average_time_in_playlist_on ENV['YT_TEST_PARTNER_PLAYLIST_DATE']}
          it { expect(average_time_in_playlist).to be_a Float }
        end

        context 'in which the playlist was not viewed' do
          let(:average_time_in_playlist) { playlist.average_time_in_playlist_on 20.years.ago}
          it { expect(average_time_in_playlist).to be_nil }
        end
      end

      describe 'average time in playlist can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(playlist.average_time_in_playlist(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(playlist.average_time_in_playlist(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(playlist.average_time_in_playlist(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(playlist.average_time_in_playlist(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'average time in playlist can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          times = playlist.average_time_in_playlist range.merge by: :range
          expect(times.size).to be 1
          expect(times[:total]).to be_a Float
        end
      end

      describe 'average time in playlist can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          average_time_in_playlist = playlist.average_time_in_playlist range
          expect(average_time_in_playlist.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          average_time_in_playlist = playlist.average_time_in_playlist range.merge by: :day
          expect(average_time_in_playlist.keys).to eq range.values
        end
      end

      describe 'average time in playlist can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          time = playlist.average_time_in_playlist range.merge by: :country
          expect(time.keys).to all(be_a String)
          expect(time.keys.map(&:length).uniq).to eq [2]
          expect(time.values).to all(be_a Float)
        end
      end

      describe 'views per playlist start can be retrieved for a specific day' do
        context 'in which the playlist was viewed' do
          let(:views_per_playlist_start) { playlist.views_per_playlist_start_on ENV['YT_TEST_PARTNER_PLAYLIST_DATE']}
          it { expect(views_per_playlist_start).to be_a Float }
        end

        context 'in which the playlist was not viewed' do
          let(:views_per_playlist_start) { playlist.views_per_playlist_start_on 20.years.ago}
          it { expect(views_per_playlist_start).to be_nil }
        end
      end

      describe 'views per playlist start can be retrieved for a range of days' do
        let(:date) { 4.days.ago }

        specify 'with a given start (:since option)' do
          expect(playlist.views_per_playlist_start(since: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:until option)' do
          expect(playlist.views_per_playlist_start(until: date).keys.max).to eq date.to_date
        end

        specify 'with a given start (:from option)' do
          expect(playlist.views_per_playlist_start(from: date).keys.min).to eq date.to_date
        end

        specify 'with a given end (:to option)' do
          expect(playlist.views_per_playlist_start(to: date).keys.max).to eq date.to_date
        end
      end

      describe 'views per playlist start can be grouped by range' do
        let(:range) { {since: ENV['YT_TEST_PARTNER_VIDEO_DATE']} }

        specify 'with the :by option set to :range' do
          views = playlist.views_per_playlist_start range.merge by: :range
          expect(views.size).to be 1
          expect(views[:total]).to be_a Float
        end
      end

      describe 'views per playlist start can be grouped by day' do
        let(:range) { {since: 4.days.ago.to_date, until: 3.days.ago.to_date} }
        let(:keys) { range.values }

        specify 'without a :by option (default)' do
          views_per_playlist_start = playlist.views_per_playlist_start range
          expect(views_per_playlist_start.keys).to eq range.values
        end

        specify 'with the :by option set to :day' do
          views_per_playlist_start = playlist.views_per_playlist_start range.merge by: :day
          expect(views_per_playlist_start.keys).to eq range.values
        end
      end

      describe 'views per playlist start can be grouped by country' do
        let(:range) { {since: 4.days.ago, until: 3.days.ago} }

        specify 'with the :by option set to :country' do
          views = playlist.views_per_playlist_start range.merge by: :country
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