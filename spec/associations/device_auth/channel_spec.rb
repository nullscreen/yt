# encoding: UTF-8

require 'spec_helper'
require 'yt/models/channel'

describe Yt::Channel, :device_app do
  let(:channel) { Yt::Channel.new id: id, auth: $account }

  describe '.snippet of existing channel' do
    let(:id) { 'UCxO1tY8h1AhOz0T4ENwmpow' }
    it { expect(channel.snippet).to be_a Yt::Snippet }
  end

  describe '.snippet of unknown channel' do
    let(:id) { 'not-a-channel-id' }
    it { expect{channel.snippet}.to raise_error Yt::Errors::NoItems }
  end

  describe '.statistics_set of existing channel' do
    let(:id) { 'UCxO1tY8h1AhOz0T4ENwmpow' }
    it { expect(channel.statistics_set).to be_a Yt::StatisticsSet }
  end

  describe '.statistics_set of unknown channel' do
    let(:id) { 'not-a-channel-id' }
    it { expect{channel.statistics_set}.to raise_error Yt::Errors::NoItems }
  end

  describe '.status of existing channel' do
    let(:id) { 'UCxO1tY8h1AhOz0T4ENwmpow' }
    it { expect(channel.status).to be_a Yt::Status }
  end

  describe '.status of unknown channel' do
    let(:id) { 'not-a-channel-id' }
    it { expect{channel.status}.to raise_error Yt::Errors::NoItems }
  end

  describe '.videos of existing channel' do
    let(:id) { 'UCxO1tY8h1AhOz0T4ENwmpow' }
    it { expect(channel.videos).to be_a Yt::Collections::Videos }
  end

  describe '.videos of unknown channel starting with UC' do
    let(:id) { 'UC-not-a-channel-id' }

    # NOTE: This test is just a reflection of YouTube irrational behavior of
    # returns 0 results if the name of an unknown channel starts with UC, but
    # returning 100,000 results otherwise (ignoring the channel filter).
    it { expect(channel.videos.count).to be 0 }
  end

  describe '.subscriptions to an existing channel' do
    let(:id) { 'UCxO1tY8h1AhOz0T4ENwmpow' }
    it { expect(channel.subscriptions).to be_a Yt::Collections::Subscriptions }

    # NOTE: These tests are slow because we *must* wait some seconds between
    # subscribing and unsubscribing to a channel, otherwise YouTube will show
    # wrong (cached) data, such as a user is subscribed when he is not.
    context 'can be added', :slow do
      before { channel.unsubscribe }
      it { expect(channel.subscribed?).to be false }
      it { expect(channel.subscribe!).to be_truthy }
    end

    context 'can be removed', :slow do
      before { channel.subscribe }
      it { expect(channel.subscribed?).to be true }
      it { expect(channel.unsubscribe!).to be_truthy }
    end
  end

  describe '.subscriptions to an unknown channel' do
    let(:id) { 'not-a-channel-id' }
    it { expect{channel.subscribe}.to raise_error Yt::Errors::RequestError }
  end

  describe '.subscriptions to my own channel' do
    let(:id) { $account.channel.id }

    # NOTE: This test is just a reflection of YouTube irrational behavior of
    # raising a 500 error when you try to subscribe to your own channel, rather
    # than a more logical 4xx error. Hopefully this will get fixed and this
    # code (and test) removed.
    it { expect{channel.subscribe}.to raise_error Yt::Errors::ServerError }
  end

  describe '.playlists of my own channel' do
    let(:id) { $account.channel.id }
    let(:title) { 'Yt Test title' }
    let(:description) { 'Yt Test description' }
    let(:tags) { ['Yt Test Tag 1', 'Yt Test Tag 2'] }
    let(:privacy_status) { 'unlisted' }
    let(:params) { {title: title, description: description, tags: tags, privacy_status: privacy_status} }

    it { expect(channel.playlists).to be_a Yt::Collections::Playlists }

    describe 'can be created' do
      after { channel.delete_playlists params }
      it { expect(channel.create_playlist params).to be_a Yt::Playlist }
      it { expect{channel.create_playlist params}.to change{channel.playlists.count}.by(1) }
    end

    describe 'can be deleted' do
      let(:title) { "Yt Test Delete All Playlists #{rand}" }
      before { channel.create_playlist params }

      it { expect(channel.delete_playlists title: %r{#{params[:title]}}).to eq [true] }
      it { expect(channel.delete_playlists params).to eq [true] }
      it { expect{channel.delete_playlists params}.to change{channel.playlists.count}.by(-1) }
    end
  end

  describe '.playlists of someone else’s channel' do
    let(:id) { 'UCxO1tY8h1AhOz0T4ENwmpow' }

    it { expect(channel.playlists).to be_a Yt::Collections::Playlists }

    describe 'cannot be created or destroyed' do
      it { expect{channel.create_playlist}.to raise_error Yt::Errors::RequestError }
      it { expect{channel.delete_playlists}.to raise_error Yt::Errors::RequestError }
    end
  end
end