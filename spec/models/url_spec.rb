# encoding: UTF-8

require 'spec_helper'
require 'yt/models/url'

describe Yt::URL do
  subject(:url) { Yt::URL.new text }

  context 'given a long video URL' do
    let(:text) { 'youtube.com/watch?v=9bZkp7q19f0' }
    it {expect(url.kind).to eq :video }
    it {expect(url.id).to eq '9bZkp7q19f0' }
    it {expect(url.username).to be_nil }
  end

  context 'given a short video URL' do
    let(:text) { 'https://youtu.be/9bZkp7q19f0' }
    it {expect(url.kind).to eq :video }
    it {expect(url.id).to eq '9bZkp7q19f0' }
  end

  context 'given an embed video URL' do
    let(:text) { 'https://www.youtube.com/embed/9bZkp7q19f0' }
    it {expect(url.kind).to eq :video }
    it {expect(url.id).to eq '9bZkp7q19f0' }
  end

  context 'given a v video URL' do
    let(:text) { 'https://www.youtube.com/v/9bZkp7q19f0' }
    it {expect(url.kind).to eq :video }
    it {expect(url.id).to eq '9bZkp7q19f0' }
  end

  context 'given a playlist-embedded video URL' do
    let(:text) { 'youtube.com/watch?v=9bZkp7q19f0&list=LLxO1tY8h1AhOz0T4ENwmpow' }
    it {expect(url.kind).to eq :video }
    it {expect(url.id).to eq '9bZkp7q19f0' }
  end

  context 'given a long channel URL' do
    let(:text) { 'http://youtube.com/channel/UCxO1tY8h1AhOz0T4ENwmpow' }
    it {expect(url.kind).to eq :channel }
    it {expect(url.id).to eq 'UCxO1tY8h1AhOz0T4ENwmpow' }
  end

  context 'given a short channel URL' do
    let(:text) { 'https://www.youtube.com/Fullscreen' }
    it {expect(url.kind).to eq :channel }
    it {expect(url.username).to eq 'Fullscreen' }
    it {expect(url.id).to be_nil }
  end

  context 'given a user’s channel URL' do
    let(:text) { 'https://www.youtube.com/user/Fullscreen' }
    it {expect(url.kind).to eq :channel }
    it {expect(url.username).to eq 'Fullscreen' }
  end

  context 'given a subscription center URL' do
    let(:text) { 'youtube.com/subscription_center?add_user=Fullscreen' }
    it {expect(url.kind).to eq :subscription }
  end

  context 'given a subscription widget URL' do
    let(:text) { 'youtube.com/subscribe_widget?p=Fullscreen' }
    it {expect(url.kind).to eq :subscription }
  end

  context 'given a subscription confirmation URL' do
    let(:text) { 'youtube.com/channel/UCxO1tY8h1AhOz0T4ENwmpow?sub_confirmation=1' }
    it {expect(url.kind).to eq :subscription }
  end

  context 'given a long playlist URL' do
    let(:text) { 'youtube.com/playlist?list=LLxO1tY8h1AhOz0T4ENwmpow' }
    it {expect(url.kind).to eq :playlist }
    it {expect(url.id).to eq 'LLxO1tY8h1AhOz0T4ENwmpow' }
  end

  context 'given a valid URL with a trailing slash' do
    let(:text) { 'https://www.youtube.com/user/Fullscreen/' }
    it {expect(url.kind).to eq :channel }
  end
end
