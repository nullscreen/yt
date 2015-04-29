require 'spec_helper'
require 'yt/models/video'

describe Yt::Video do
  subject(:video) { Yt::Video.new attrs }

  describe '#snippet' do
    context 'given fetching a video returns a snippet' do
      let(:attrs) { {snippet: {"title"=>"Fullscreen Creator Platform"}} }
      it { expect(video.snippet).to be_a Yt::Snippet }
    end
  end

  describe '#deleted?' do
    context 'given fetching a status returns uploadStatus "deleted"' do
      let(:attrs) { {status: {"uploadStatus"=>"deleted"}} }
      it { expect(video).to be_deleted }
    end

    context 'given fetching a status does not return uploadStatus "deleted"' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded"}} }
      it { expect(video).not_to be_deleted }
    end
  end

  describe '#failed?' do
    context 'given fetching a status returns uploadStatus "failed"' do
      let(:attrs) { {status: {"uploadStatus"=>"failed"}} }
      it { expect(video).to be_failed }
    end

    context 'given fetching a status does not return uploadStatus "failed"' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded"}} }
      it { expect(video).not_to be_failed }
    end
  end

  describe '#processed?' do
    context 'given fetching a status returns uploadStatus "processed"' do
      let(:attrs) { {status: {"uploadStatus"=>"processed"}} }
      it { expect(video).to be_processed }
    end

    context 'given fetching a status does not return uploadStatus "processed"' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded"}} }
      it { expect(video).not_to be_processed }
    end
  end

  describe '#rejected?' do
    context 'given fetching a status returns uploadStatus "rejected"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected"}} }
      it { expect(video).to be_rejected }
    end

    context 'given fetching a status does not return uploadStatus "rejected"' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded"}} }
      it { expect(video).not_to be_rejected }
    end
  end

  describe '#uploading?' do
    context 'given fetching a status returns uploadStatus "uploaded"' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded"}} }
      it { expect(video).to be_uploading }
    end

    context 'given fetching a status does not return uploadStatus "uploaded"' do
      let(:attrs) { {status: {"uploadStatus"=>"failed"}} }
      it { expect(video).not_to be_uploading }
    end
  end



  describe '#statistics_set' do
    context 'given fetching a video returns statistics' do
      let(:attrs) { {statistics: {"viewCount"=>"202"}} }
      it { expect(video.statistics_set).to be_a Yt::StatisticsSet }
    end
  end

  describe '#content_details' do
    context 'given fetching a video returns content details' do
      let(:attrs) { {content_details: {"definition"=>"hd"}} }
      it { expect(video.content_detail).to be_a Yt::ContentDetail }
    end
  end

  describe '#update' do
    let(:attrs) { {id: 'MESycYJytkU', snippet: {'title'=>'old'}} }
    before { expect(video).to receive(:do_update).and_yield 'snippet'=>{'title'=>'new'} }

    it { expect(video.update title: 'new').to be true }
    it { expect{video.update title: 'new'}.to change{video.title} }
  end

  describe '#delete' do
    let(:attrs) { {id: 'video-id'} }

    context 'given an existing video' do
      before { expect(video).to receive(:do_delete).and_yield }

      it { expect(video.delete).to be true }
      it { expect{video.delete}.to change{video.exists?} }
    end
  end
end