# encoding: UTF-8
require 'spec_helper'
require 'yt/models/channel'

describe Yt::Channel, :device_app do
  subject(:channel) { Yt::Channel.new id: id, auth: $account }

  context 'given someone else’s channel' do
    let(:id) { 'UCxO1tY8h1AhOz0T4ENwmpow' }

    it 'returns valid metadata' do
      expect(channel.title).to be_a String
      expect(channel.description).to be_a String
      expect(channel.thumbnail_url).to be_a String
      expect(channel.published_at).to be_a Time
      expect(channel.privacy_status).to be_in Yt::Status::PRIVACY_STATUSES
      expect(channel.view_count).to be_an Integer
      expect(channel.comment_count).to be_an Integer
      expect(channel.video_count).to be_an Integer
      expect(channel.subscriber_count).to be_an Integer
      expect(channel.subscriber_count_visible?).to be_in [true, false]
    end

    it { expect(channel.videos.first).to be_a Yt::Video }
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

    # NOTE: These tests are slow because they go through multiple pages of
    # results and do so to test that we can overcome YouTube’s limitation of
    # only returning the first 500 results for each query.
    context 'with more than 500 videos' do
      let(:id) { 'UCsmvakQZlvGsyjyOhmhvOsw' }
      it { expect(channel.video_count).to be > 500 }
      it { expect(channel.videos.count).to be > 500 }
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

    # @note: this test is just a reflection of YouTube irrational behavior of
    # raising a 500 error when you try to subscribe to your own channel.
    # `subscribe` will ignore the error, but `subscribe!` will raise it.
    it { expect{channel.subscribe!}.to raise_error Yt::Errors::ServerError }
    it { expect(channel.subscribe).to be_falsey }

    it 'returns valid reports for channel-related metrics' do
      # Some reports are only available to Content Owners.
      # See content owner test for more details about what the methods return.
      expect{channel.views}.not_to raise_error
      expect{channel.comments}.not_to raise_error
      expect{channel.likes}.not_to raise_error
      expect{channel.dislikes}.not_to raise_error
      expect{channel.shares}.not_to raise_error
      expect{channel.earnings}.to raise_error Yt::Errors::Unauthorized
      expect{channel.impressions}.to raise_error Yt::Errors::Unauthorized

      expect{channel.views_on 3.days.ago}.not_to raise_error
      expect{channel.comments_on 3.days.ago}.not_to raise_error
      expect{channel.likes_on 3.days.ago}.not_to raise_error
      expect{channel.dislikes_on 3.days.ago}.not_to raise_error
      expect{channel.shares_on 3.days.ago}.not_to raise_error
      expect{channel.earnings_on 3.days.ago}.to raise_error Yt::Errors::Unauthorized
      expect{channel.impressions_on 3.days.ago}.to raise_error Yt::Errors::Unauthorized
    end

    it 'returns valid reports for channel-related demographics' do
      expect{channel.viewer_percentages}.not_to raise_error
      expect{channel.viewer_percentage}.not_to raise_error
    end
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