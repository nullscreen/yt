require 'spec_helper'
require 'yt/associations/details_sets'

describe Yt::Associations::DetailsSets, :server_app do
  subject(:video) { Yt::Video.new id: video_id }

  describe '#details_set' do
    context 'given an existing video' do
      let(:video_id) { 'MESycYJytkU' }
      it { expect(video.details_set).to be_a Yt::DetailsSet }
    end

    context 'given an unknown video' do
      let(:video_id) { 'not-a-video-id' }
      it { expect{video.details_set}.to raise_error Yt::Errors::NoItems }
    end
  end
end