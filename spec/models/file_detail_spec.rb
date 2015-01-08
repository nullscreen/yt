require 'spec_helper'
require 'yt/models/file_detail'

describe Yt::FileDetail do
  subject(:file_detail) { Yt::FileDetail.new data: data }

  describe '#file_name' do
    context 'given a video with fileName' do
      let(:data) { {'fileName'=>'file_with_a_fileName.mp4'} }
      it { expect(file_detail.file_name).to eq 'file_with_a_fileName.mp4' }
    end

    context 'given a video with a fileName that includes spaces' do
      let(:data) { {'fileName'=>'This file has spaces.avi'} }
      it { expect(file_detail.file_name).to eq 'This file has spaces.avi' }
    end

    context 'given a video with a fileName that includes multiple periods' do
      let(:data) { {'fileName'=>'this.file.has.periods.mp4'} }
      it { expect(file_detail.file_name).to eq 'this.file.has.periods.mp4' }
    end

    context 'given a video with no fileName' do
      let(:data) { {} }
      it { expect(file_detail.file_name).to be_nil }
    end

    context 'given a non-video file with fileName' do
      let(:data) { {'fileName'=>'someTextFile.txt'} }
      it { expect(file_detail.file_name).to eq 'someTextFile.txt' }
    end
  end

  describe '#file_size' do
    context 'given a video with fileSize' do
      let(:data) { {'fileSize'=>'8000000'} }
      it { expect(file_detail.file_size).to eq 8000000 }
    end

    context 'given a video without fileSize' do
      let(:data) { {} }
      it { expect(file_detail.file_size).to be_nil }
    end
  end

  describe '#file_type' do
    context 'given a video file' do
      let(:data) { {'fileType'=>'video'} }
      it { expect(file_detail.file_type).to eq 'video' }
    end

    context 'given an audio file' do
      let(:data) { {'fileType'=>'audio'} }
      it { expect(file_detail.file_type).to eq 'audio' }
    end

    context 'given an archive file' do
      let(:data) { {'fileType'=>'archive'} }
      it { expect(file_detail.file_type).to eq 'archive' }
    end

    context 'given a document file' do
      let(:data) { {'fileType'=>'document'} }
      it { expect(file_detail.file_type).to eq 'document' }
    end

    context 'given an image file' do
      let(:data) { {'fileType'=>'image'} }
      it { expect(file_detail.file_type).to eq 'image' }
    end

    context 'given a project file' do
      let(:data) { {'fileType'=>'project'} }
      it { expect(file_detail.file_type).to eq 'project' }
    end

    context "given a file with 'other' type" do
      let(:data) { {'fileType'=>'other'} }
      it { expect(file_detail.file_type).to eq 'other' }
    end
  end

  describe '#container' do
    context 'given a video with a container' do
      let(:data) { {'container'=>'mov'} }
      it { expect(file_detail.container).to eq 'mov' }
    end

    context 'given a file with no container' do
      let(:data) { {} }
      it { expect(file_detail.file_type).to be_nil }
    end
  end
end
