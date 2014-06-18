require 'spec_helper'
require 'yt/models/details_set'

describe Yt::DetailsSet do
  subject(:details_set) { Yt::DetailsSet.new data: data }

  describe '#duration' do
    context 'given a details_set with duration in hours, minutes, seconds' do
      let(:data) { {"duration"=>"PT1H18M52S"} }
      it { expect(details_set.duration).to eq 4732 }
    end

    context 'given a details_set with duration in minutes and seconds' do
      let(:data) { {"duration"=>"PT2M51S"} }
      it { expect(details_set.duration).to eq 171 }
    end

    context 'given a details_set with duration in minutes' do
      let(:data) { {"duration"=>"PT2M"} }
      it { expect(details_set.duration).to eq 120 }
    end

    context 'given a details_set with duration in seconds' do
      let(:data) { {"duration"=>"PT51S"} }
      it { expect(details_set.duration).to eq 51 }
    end
  end

  describe '#stereoscopic?' do
    context 'given a 3D video' do
      let(:data) { {"dimension"=>"3d"} }
      it { expect(details_set).to be_stereoscopic }
    end

    context 'given a 2D video' do
      let(:data) { {"dimension"=>"2d"} }
      it { expect(details_set).not_to be_stereoscopic }
    end
  end

  describe '#hd?' do
    context 'given a high-definition video' do
      let(:data) { {"definition"=>"hd"} }
      it { expect(details_set).to be_hd }
    end

    context 'given a standard-definition video' do
      let(:data) { {"definition"=>"sd"} }
      it { expect(details_set).not_to be_hd }
    end
  end

  describe '#captioned?' do
    context 'given a video with captions' do
      let(:data) { {"caption"=>"true"} }
      it { expect(details_set).to be_captioned }
    end

    context 'given a video without captions' do
      let(:data) { {"caption"=>"false"} }
      it { expect(details_set).not_to be_captioned }
    end
  end

  describe '#captioned?' do
    context 'given a video with licensed content' do
      let(:data) { {"licensedContent"=>true} }
      it { expect(details_set).to be_licensed }
    end

    context 'given a video without licensed content' do
      let(:data) { {"licensedContent"=>false} }
      it { expect(details_set).not_to be_licensed }
    end
  end
end