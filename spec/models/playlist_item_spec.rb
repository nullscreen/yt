require 'spec_helper'
require 'yt/models/playlist_item'

describe Yt::PlaylistItem do
  subject(:playlist_item) { Yt::PlaylistItem.new attrs }

  describe '#position' do
    context 'given fetching a playlist item returns a snippet' do
      let(:attrs) { {snippet: {"position"=>0}} }
      it { expect(playlist_item.position).to be 0 }
    end
  end

  describe '#video' do
    context 'given fetching a playlist item returns a snippet' do
      let(:attrs) { {snippet: {"title"=>"Fullscreen"}} }
      it { expect(playlist_item.video).to be_a Yt::Video }
      it { expect(playlist_item.video.title).to eq "Fullscreen" }
    end
  end

  describe '#delete' do
    let(:attrs) { {id: 'playlist-item-id'} }

    context 'given an existing playlist item' do
      before { playlist_item.stub(:do_delete).and_yield }

      it { expect(playlist_item.delete).to be_true }
      it { expect{playlist_item.delete}.to change{playlist_item.exists?} }
    end
  end
end