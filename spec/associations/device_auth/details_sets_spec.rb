require 'spec_helper'
require 'yt/associations/details_sets'

describe Yt::Associations::DetailsSets, :device_app do
  let(:video) { Yt::Video.new id: 'fsdfsfsdMESycYJytkU', auth: $account }

  describe '#details_set' do
    context 'given an existing video' do
      let(:video) { Yt::Video.new id: 'MESycYJytkU', auth: $account }
      it { expect(video.details_set).to be_a Yt::DetailsSet }
    end

    context 'given an unknown video' do
      let(:video) { Yt::Video.new id: 'not-a-video-id', auth: $account }
      it { expect{video.details_set}.to raise_error Yt::Errors::NoItems }
    end
  end
end