require 'spec_helper'
require 'yt/models/statistics_set'

describe Yt::StatisticsSet do
  subject(:statistics_set) { Yt::StatisticsSet.new data: data }
  let(:value) { 42 }

  describe '#view_count' do
    context 'given a video with views' do
      let(:data) { {"viewCount"=>value} }
      it { expect(statistics_set.view_count).to be value }
    end
  end

  describe '#comment_count' do
    context 'given a video with comments' do
      let(:data) { {"commentCount"=>value} }
      it { expect(statistics_set.comment_count).to be value }
    end
  end

  describe '#like_count' do
    context 'given a video with likes' do
      let(:data) { {"likeCount"=>value} }
      it { expect(statistics_set.like_count).to be value }
    end
  end

  describe '#dislike_count' do
    context 'given a video with dislikes' do
      let(:data) { {"dislikeCount"=>value} }
      it { expect(statistics_set.dislike_count).to be value }
    end
  end

  describe '#favorite_count' do
    context 'given a video with favorites' do
      let(:data) { {"favoriteCount"=>value} }
      it { expect(statistics_set.favorite_count).to be value }
    end
  end

  describe '#video_count' do
    context 'given a video with videos' do
      let(:data) { {"videoCount"=>value} }
      it { expect(statistics_set.video_count).to be value }
    end
  end

  describe '#subscriber_count' do
    context 'given a video with subscribers' do
      let(:data) { {"subscriberCount"=>value} }
      it { expect(statistics_set.subscriber_count).to be value }
    end
  end

  describe '#subscriber_count_visible?' do
    context 'given a video with publicly visible subscribers' do
      let(:data) { {"hiddenSubscriberCount"=>false} }
      it { expect(statistics_set).to be_subscriber_count_visible }
    end

    context 'given a video with hidden subscribers' do
      let(:data) { {"hiddenSubscriberCount"=>true} }
      it { expect(statistics_set).not_to be_subscriber_count_visible }
    end
  end
end