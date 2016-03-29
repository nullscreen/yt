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

  describe '#top_level_comment' do
    context 'given a snippet with a top level comment' do
      let(:attrs) { {snippet: {"topLevelComment"=> {}}} }
      it { expect(comment_thread.top_level_comment).to be_a Yt::Comment }
    end
  end

  describe 'attributes from #top_level_comment delegations' do
    context 'with values' do
      let(:attrs) { {snippet: {"topLevelComment"=> {"id" => "xyz123", "snippet" => {
        "textDisplay" => "funny video!",
        "authorDisplayName" => "fullscreen",
        "likeCount" => 99,
        "updatedAt" => "2016-03-22T12:56:56.3Z"}}}} }

      it { expect(comment_thread.top_level_comment.id).to eq 'xyz123' }
      it { expect(comment_thread.text_display).to eq 'funny video!' }
      it { expect(comment_thread.author_display_name).to eq 'fullscreen' }
      it { expect(comment_thread.like_count).to eq 99 }
      it { expect(comment_thread.updated_at).to eq Time.parse('2016-03-22T12:56:56.3Z') }
    end

    context 'without values' do
      let(:attrs) { {snippet: {"topLevelComment"=> {"snippet" => {}}}} }

      it { expect(comment_thread.text_display).to be_nil }
      it { expect(comment_thread.author_display_name).to be_nil }
      it { expect(comment_thread.like_count).to be_nil }
      it { expect(comment_thread.updated_at).to be_nil }
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
