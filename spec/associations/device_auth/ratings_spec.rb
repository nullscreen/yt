require 'spec_helper'
require 'yt/models/video'

describe Yt::Associations::Ratings, :device_app do
  describe '#rating' do
    context 'given an existing video' do
      let(:video) { Yt::Video.new id: 'MESycYJytkU', auth: $account }

      context 'that I like' do
        before { video.like }
        it { expect(video).to be_liked }
        it { expect(video.dislike).to be true }
      end

      context 'that I dislike' do
        before { video.dislike }
        it { expect(video).not_to be_liked }
        it { expect(video.like).to be true }
      end

      context 'that I am indifferent to' do
        before { video.unlike }
        it { expect(video).not_to be_liked }
        it { expect(video.like).to be true }
      end
    end
  end
end