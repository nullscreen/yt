require 'spec_helper'
require 'yt/models/url'

describe Yt::URL do
  subject(:url) { Yt::URL.new text }

  context 'given a YouTube playlist URL' do
    let(:text) { "https://www.youtube.com/playlist?list=#{id}" }

    describe 'works with existing playlists' do
      let(:id) { 'LLxO1tY8h1AhOz0T4ENwmpow' }
      it {expect(url.id).to eq id }
    end

    describe 'works with unknown playlists' do
      let(:id) { 'PL12--not-a-playlist' }
      it {expect(url.id).to eq id }
    end
  end

  context 'given a YouTube video URL' do
    let(:text) { "https://www.youtube.com/watch?v=#{id}" }

    describe 'works with existing videos' do
      let(:id) { 'gknzFj_0vvY' }
      it {expect(url.id).to eq id }
    end

    describe 'works with unknown videos' do
      let(:id) { 'abc123abc12' }
      it {expect(url.id).to eq id }
    end
  end

  context 'given a YouTube channel URL in the ID form' do
    let(:text) { "https://www.youtube.com/channel/#{id}" }

    describe 'works with existing channels' do
      let(:id) { 'UC4lU5YG9QDgs0X2jdnt7cdQ' }
      it {expect(url.id).to eq id }
    end

    describe 'works with unknown channels' do
      let(:id) { 'UC-not-an-actual-channel' }
      it {expect(url.id).to eq id }
    end
  end

  context 'given an existing YouTube channel' do
    let(:text) { 'youtube.com/channel/UCxO1tY8h1AhOz0T4ENwmpow' }
    it {expect(url.kind).to eq :channel }
  end

  context 'given an existing YouTube video' do
    let(:text) { 'youtube.com/watch?v=gknzFj_0vvY' }
    it {expect(url.kind).to eq :video }
  end

  context 'given an existing YouTube playlist' do
    let(:text) { 'youtube.com/playlist?list=LLxO1tY8h1AhOz0T4ENwmpow' }
    it {expect(url.kind).to eq :playlist }
  end

  context 'given an unknown YouTube channel URL' do
    let(:text) { 'youtube.com/channel/UC-too-short-to-be-an-id' }
    it {expect(url.kind).to eq :channel }
  end

  context 'given an unknown YouTube video URL' do
    let(:text) { 'youtu.be/not-an-id' }
    it {expect(url.kind).to eq :unknown }
  end

  context 'given an unknown text' do
    let(:text) { 'not-really-anything---' }
    it {expect(url.kind).to eq :unknown }
  end
end
