# encoding: UTF-8
require 'spec_helper'
require 'yt/collections/comment_threads'
require 'yt/models/video'
require 'yt/models/channel'

describe Yt::Collections::CommentThreads, :server_app, :vcr do
  context "without parent association", :ruby2 do
    subject(:comment_threads) { Yt::Collections::CommentThreads.new }

    specify 'without given any of id, videoId, channelId or allThreadsRelatedToChannelId param, raise request error', :ruby2 do
      expect{ comment_threads.size }.to raise_error(Yt::Errors::RequestError)
    end

    specify 'with a id param, only return one comment thread' do
      expect(comment_threads.where(id: 'z13zytsilxbexh30e233gdyyttngfjfz104').size).to eq 1
    end

    specify 'with a videoId param, returns comment threads for the video', focus: true do
      expect(comment_threads.where(videoId: 'MsplPPW7tFo').size).to be > 0
    end

    specify 'with a channelId param, returns comment threads for the channel' do
      expect(comment_threads.where(channelId: 'UC-lHJZR3Gqxm24_Vd_AJ5Yw').size).to be > 0
    end
  end

  context "with parent association", :ruby2 do
    subject(:comment_threads) { Yt::Collections::CommentThreads.new parent: parent}

    context "parent as video" do
      let(:parent) { Yt::Models::Video.new id: 'MsplPPW7tFo' }
      it { expect(comment_threads.size).to be > 0 }
    end

    context "parent as channel" do
      let(:parent) { Yt::Models::Channel.new id: 'UC-lHJZR3Gqxm24_Vd_AJ5Yw' }
      it { expect(comment_threads.size).to be > 0 }
    end
  end
end
