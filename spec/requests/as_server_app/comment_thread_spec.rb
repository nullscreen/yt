require 'spec_helper'
require 'yt/models/comment_thread'

describe Yt::CommentThread, :server_app do
  subject(:comment_thread) { Yt::CommentThread.new attrs }

  context 'given an existing comment thread ID about a channel' do
    let(:attrs) { {id: 'z13vsnnbwtv4sbnug232erczcmi3wzaug'} }

    it { expect(comment_thread.video_id).to be_nil }
    it { expect(comment_thread.total_reply_count).to be_an Integer }
    it { expect(comment_thread.can_reply?).to be false }
    it { expect(comment_thread).to be_public }
  end

  context 'given an comment thread ID about a video' do
    let(:attrs) { {id: 'z13ij10h2z3qxpcte23hc5oh2vfzeptk4'} }
    it { expect(comment_thread.video_id).to be_a String }
  end

  context 'given an unknown comment thread ID' do
    let(:attrs) { {id: 'not-a-comment-thread-id'} }
    it { expect{comment_thread.total_reply_count}.to raise_error Yt::Errors::NoItems }
  end

end
