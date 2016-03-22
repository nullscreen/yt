require 'spec_helper'
require 'yt/models/comment_thread'

describe Yt::CommentThread do
  subject(:comment_thread) { Yt::CommentThread.new attrs }

  describe '#snippet' do
    context 'given fetching a comment thread returns a snippet' do
      let(:attrs) { {snippet: {"videoId" => "12345"}} }
      it { expect(comment_thread.snippet).to be_a Yt::Snippet }
    end
  end

  describe '#video_id' do
    context 'given a snippet with a video id' do
      let(:attrs) { {snippet: {"videoId"=>"12345"}} }
      it { expect(comment_thread.video_id).to eq '12345' }
    end

    context 'given a snippet without a video id' do
      let(:attrs) { {snippet: {}} }
      it { expect(comment_thread.video_id).to be_nil }
    end
  end

  describe '#total_reply_count' do
    context 'given a snippet with a total reply count' do
      let(:attrs) { {snippet: {"totalReplyCount"=>1}} }
      it { expect(comment_thread.total_reply_count).to eq 1 }
    end

    context 'given a snippet without a total reply count' do
      let(:attrs) { {snippet: {}} }
      it { expect(comment_thread.total_reply_count).to be_nil }
    end
  end

  describe '#can_reply?' do
    context 'given a snippet with canReply set' do
      let(:attrs) { {snippet: {"canReply"=>true}} }
      it { expect(comment_thread.can_reply?).to be true }
    end

    context 'given a snippet without canReply set' do
      let(:attrs) { {snippet: {}} }
      it { expect(comment_thread.can_reply?).to be false }
    end
  end

  describe '#is_public?' do
    context 'given a snippet with isPublic set' do
      let(:attrs) { {snippet: {"isPublic"=>true}} }
      it { expect(comment_thread).to be_public }
    end

    context 'given a snippet without isPublic set' do
      let(:attrs) { {snippet: {}} }
      it { expect(comment_thread).to_not be_public }
    end
  end
end
