require 'spec_helper'
require 'yt/models/url'

describe Yt::URL, :server_app, :vcr do
  subject(:url) { Yt::URL.new text }

  context 'given an existing YouTube channel URL' do
    let(:text) { "youtube.com/channel/UCwCnUcLcb9-eSrHa_RQGkQQ" }

    it {expect(url.resource).to be_a Yt::Channel }
    it {expect(url.resource.title).to be }
  end

  context 'given an existing YouTube video URL' do
    let(:text) { "youtube.com/watch?v=gknzFj_0vvY" }

    it {expect(url.resource).to be_a Yt::Video }
    it {expect(url.resource.title).to be }
  end

  context 'given an unknown YouTube video URL' do
    let(:text) { "youtu.be/invalid-id-" }

    it {expect(url.resource).to be_a Yt::Video }
    it {expect{url.resource.title}.to raise_error Yt::Errors::NoItems }
  end

  context 'given an existing YouTube playlist URL' do
    let(:text) { "youtube.com/playlist?list=PL-LeTutc9GRKD3yBDhnRF_yE8UTaQI5Jf" }

    it {expect(url.resource).to be_a Yt::Playlist }
    it {expect(url.resource.title).to be }
  end

  context 'given an unknown YouTube playlist URL' do
    let(:text) { "https://www.youtube.com/playlist?list=invalid-id-" }

    it {expect(url.resource).to be_a Yt::Playlist }
    it {expect{url.resource.title}.to raise_error Yt::Errors::NoItems }
  end

  context 'given an unknown text' do
    let(:text) { 'not-really-anything---' }

    it {expect{url.resource}.to raise_error Yt::Errors::NoItems }
  end

  # # TODO: need to fix our code, as YouTube behavior changes
  # context 'given a YouTube channel URL in the name form' do
  #   let(:text) { "http://www.youtube.com/#{name}" }

  #   describe 'works when the name matches the custom URL' do
  #     let(:name) { 'nbcsports' }
  #     it {expect(url.id).to eq 'UCqZQlzSHbVJrwrn5XvzrzcA' }
  #   end

  #   describe 'works when the name matches the username' do
  #     let(:name) { '2012NBCOlympics' }
  #     it {expect(url.id).to eq 'UCqZQlzSHbVJrwrn5XvzrzcA' }
  #   end

  #   describe 'fails with unknown channels' do
  #     let(:name) { 'not-an-actual-channel' }
  #     it {expect{url.id}.to raise_error Yt::Errors::NoItems }
  #   end
  # end

  # context 'given a YouTube channel URL in the custom form' do
  #   let(:text) { "https://youtube.com/c/#{name}" }

  #   describe 'works with existing channels' do
  #     let(:name) { 'ogeeku' }
  #     it {expect(url.id).to eq 'UC4nG_NxJniKoB-n6TLT2yaw' }
  #   end

  #   describe 'fails with unknown channels' do
  #     let(:name) { 'not-an-actual-channel' }
  #     it {expect{url.id}.to raise_error Yt::Errors::NoItems }
  #   end
  # end

  # context 'given a YouTube channel URL in the username form' do
  #   let(:text) { "youtube.com/user/#{name}" }

  #   describe 'works with existing channels' do
  #     let(:name) { 'ogeeku' }
  #     it {expect(url.id).to eq 'UC4lU5YG9QDgs0X2jdnt7cdQ' }
  #   end

  #   describe 'fails with unknown channels' do
  #     let(:name) { 'not-an-actual-channel' }
  #     it {expect{url.id}.to raise_error Yt::Errors::NoItems }
  #   end
  # end
end
