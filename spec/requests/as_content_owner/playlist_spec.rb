# encoding: UTF-8
require 'spec_helper'
require 'yt/models/channel'
require 'yt/models/playlist'

describe Yt::Playlist, :partner do
  subject(:playlist) { Yt::Playlist.new id: id, auth: $content_owner }

  context 'given a playlist of a partnered channel', :partner do
    context 'managed by the authenticated Content Owner' do
      let(:id) { ENV['YT_TEST_PARTNER_PLAYLIST_ID'] }

      describe 'playlist starts can be retrieved for a specific day' do
        context 'in which the playlist was viewed' do
          let(:playlist_starts) { playlist.playlist_starts_on ENV['YT_TEST_PARTNER_PLAYLIST_DATE']}
          it { expect(playlist_starts).to be_a Float }
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
    end

    context 'not managed by the authenticated Content Owner' do
      let(:id) { 'PLbpi6ZahtOH6J5oPGySZcmbRfT7Hyq1sZ' }

      specify 'playlist starts cannot be retrieved' do
        expect{playlist.playlist_starts}.to raise_error Yt::Errors::Forbidden
      end
    end
  end
end