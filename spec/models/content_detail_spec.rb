require 'spec_helper'
require 'yt/models/content_detail'

describe Yt::ContentDetail do
  subject(:content_detail) { Yt::ContentDetail.new data: data }

  describe '#duration' do
    # video 2XwmldWC_Ls has duration P1W2DT6H21M32S
    context 'given a content_detail with duration in weeks, days, hours, minutes' do
      let(:data) { {"duration"=>"P1W2DT6H21M32S"}}
      it { expect(content_detail.duration).to eq 800492 }
    end
    # video FvHiLLkPhQE has duration P1D (exactly one day)
    context 'given a content_detail with duration in days' do
      let(:data) { {"duration"=>"P1D"}}
      it { expect(content_detail.duration).to eq 86400 }
    end
    context 'given a content_detail with duration in hours, minutes, seconds' do
      let(:data) { {"duration"=>"PT1H18M52S"} }
      it { expect(content_detail.duration).to eq 4732 }
    end

    context 'given a content_detail with duration in minutes and seconds' do
      let(:data) { {"duration"=>"PT2M51S"} }
      it { expect(content_detail.duration).to eq 171 }
    end

    context 'given a content_detail with duration in minutes' do
      let(:data) { {"duration"=>"PT2M"} }
      it { expect(content_detail.duration).to eq 120 }
    end

    context 'given a content_detail with duration in seconds' do
      let(:data) { {"duration"=>"PT51S"} }
      it { expect(content_detail.duration).to eq 51 }
    end
  end

  describe '#stereoscopic?' do
    context 'given a 3D video' do
      let(:data) { {"dimension"=>"3d"} }
      it { expect(content_detail).to be_stereoscopic }
    end

    context 'given a 2D video' do
      let(:data) { {"dimension"=>"2d"} }
      it { expect(content_detail).not_to be_stereoscopic }
    end
  end

  describe '#hd?' do
    context 'given a high-definition video' do
      let(:data) { {"definition"=>"hd"} }
      it { expect(content_detail).to be_hd }
    end

    context 'given a standard-definition video' do
      let(:data) { {"definition"=>"sd"} }
      it { expect(content_detail).not_to be_hd }
    end
  end

  describe '#captioned?' do
    context 'given a video with captions' do
      let(:data) { {"caption"=>"true"} }
      it { expect(content_detail).to be_captioned }
    end

    context 'given a video without captions' do
      let(:data) { {"caption"=>"false"} }
      it { expect(content_detail).not_to be_captioned }
    end
  end

  describe '#captioned?' do
    context 'given a video with licensed content' do
      let(:data) { {"licensedContent"=>true} }
      it { expect(content_detail).to be_licensed }
    end

    context 'given a video without licensed content' do
      let(:data) { {"licensedContent"=>false} }
      it { expect(content_detail).not_to be_licensed }
    end
  end
end