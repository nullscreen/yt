# encoding: UTF-8

require 'spec_helper'
require 'yt/models/channel'

describe Yt::Channel, :device_app do
  subject(:channel) { Yt::Channel.new id: id, auth: $account }

  context 'given someone else’s channel' do
    let(:id) { 'UCxO1tY8h1AhOz0T4ENwmpow' }

    it 'returns valid snippet data' do
      expect(channel.snippet).to be_a Yt::Snippet
      expect(channel.title).to be_a String
      expect(channel.description).to be_a Yt::Description
      expect(channel.thumbnail_url).to be_a String
      expect(channel.published_at).to be_a Time
    end

    it { expect(channel.status).to be_a Yt::Status }
    it { expect(channel.statistics_set).to be_a Yt::StatisticsSet }
    it { expect(channel.videos).to be_a Yt::Collections::Videos }
    it { expect(channel.videos.first).to be_a Yt::Video }
    it { expect(channel.playlists).to be_a Yt::Collections::Playlists }
    it { expect(channel.playlists.first).to be_a Yt::Playlist }
    it { expect{channel.create_playlist}.to raise_error Yt::Errors::RequestError }
    it { expect{channel.delete_playlists}.to raise_error Yt::Errors::RequestError }
    it { expect(channel.subscriptions).to be_a Yt::Collections::Subscriptions }

    # NOTE: These tests are slow because we *must* wait some seconds between
    # subscribing and unsubscribing to a channel, otherwise YouTube will show
    # wrong (cached) data, such as a user is subscribed when he is not.
    context 'that I am not subscribed to', :slow do
      before { channel.unsubscribe }
      it { expect(channel.subscribed?).to be false }
      it { expect(channel.subscribe!).to be_truthy }
    end

    context 'that I am subscribed to', :slow do
      before { channel.subscribe }
      it { expect(channel.subscribed?).to be true }
      it { expect(channel.unsubscribe!).to be_truthy }
    end
  end

  context 'given my own channel' do
    let(:id) { $account.channel.id }
    let(:title) { 'Yt Test title' }
    let(:description) { 'Yt Test description' }
    let(:tags) { ['Yt Test Tag 1', 'Yt Test Tag 2'] }
    let(:privacy_status) { 'unlisted' }
    let(:params) { {title: title, description: description, tags: tags, privacy_status: privacy_status} }

    describe 'playlists can be added' do
      after { channel.delete_playlists params }
      it { expect(channel.create_playlist params).to be_a Yt::Playlist }
      it { expect{channel.create_playlist params}.to change{channel.playlists.count}.by(1) }
    end

    describe 'playlists can be deleted' do
      let(:title) { "Yt Test Delete All Playlists #{rand}" }
      before { channel.create_playlist params }

      it { expect(channel.delete_playlists title: %r{#{params[:title]}}).to eq [true] }
      it { expect(channel.delete_playlists params).to eq [true] }
      it { expect{channel.delete_playlists params}.to change{channel.playlists.count}.by(-1) }
    end

    # NOTE: This test is just a reflection of YouTube irrational behavior of
    # raising a 500 error when you try to subscribe to your own channel,
    # rather than a more logical 4xx error. Hopefully this will get fixed
    # and this code (and test) removed.
    it { expect{channel.subscribe}.to raise_error Yt::Errors::ServerError }
  end

  context 'given an unknown channel' do
    let(:id) { 'not-a-channel-id' }

    it { expect{channel.snippet}.to raise_error Yt::Errors::NoItems }
    it { expect{channel.status}.to raise_error Yt::Errors::NoItems }
    it { expect{channel.statistics_set}.to raise_error Yt::Errors::NoItems }
    it { expect{channel.subscribe}.to raise_error Yt::Errors::RequestError }

    describe 'starting with UC' do
      let(:id) { 'UC-not-a-channel-id' }

      # NOTE: This test is just a reflection of YouTube irrational behavior of
      # returns 0 results if the name of an unknown channel starts with UC, but
      # returning 100,000 results otherwise (ignoring the channel filter).
      it { expect(channel.videos.count).to be 0 }
    end
  end
end

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
    end

    context 'not managed by the authenticated Content Owner' do
      let(:id) { 'UCBR8-60-B28hp2BmDPdntcQ' }

      it { expect{channel.earnings}.to raise_error Yt::Errors::Forbidden }
      it { expect{channel.views}.to raise_error Yt::Errors::Forbidden }
    end
  end
end