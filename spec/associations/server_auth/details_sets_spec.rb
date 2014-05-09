require 'spec_helper'
require 'yt/associations/details_sets'

describe Yt::Associations::DetailsSets, scenario: :server_app do
  let(:video) { Yt::Video.new id: 'fsdfsfsdMESycYJytkU' }

  describe '#details_set' do
    context 'given an existing video' do
      let(:video) { Yt::Video.new id: 'MESycYJytkU' }
      it { expect(video.details_set).to be_a Yt::DetailsSet }
    end

    context 'given an unknown video' do
      let(:video) { Yt::Video.new id: 'not-a-video-id' }
      it { expect(video.details_set).to be_nil }
    end
  end
end