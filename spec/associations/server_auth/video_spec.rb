require 'spec_helper'
require 'yt/models/video'

describe Yt::Video, :server_app do
  subject(:video) { Yt::Video.new id: id }

  context 'given an existing video' do
    let(:id) { 'MESycYJytkU' }

    it { expect(video.details_set).to be_a Yt::DetailsSet }
    it { expect(video.snippet).to be_a Yt::Snippet }
    it { expect(video.status).to be_a Yt::Status }
  end

  context 'given an unknown video' do
    let(:id) { 'not-a-video-id' }

    it { expect{video.details_set}.to raise_error Yt::Errors::NoItems }
    it { expect{video.snippet}.to raise_error Yt::Errors::NoItems }
    it { expect{video.status}.to raise_error Yt::Errors::NoItems }
  end
end