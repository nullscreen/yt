require 'spec_helper'
require 'yt/models/channel'

describe Yt::Channel do
  subject(:channel) { Yt::Channel.new attrs }

  describe '#title' do
    context 'given a snippet with a title' do
      let(:attrs) { {snippet: {"title"=>"Fullscreen"}} }
      it { expect(channel.title).to eq 'Fullscreen' }
    end

    context 'given a snippet without a title' do
      let(:attrs) { {snippet: {}} }
      it { expect(channel.title).to eq '' }
    end
  end

  describe '#description' do
    context 'given a snippet with a description' do
      let(:attrs) { {snippet: {"description"=>"A cool channel."}} }
      it { expect(channel.description).to eq 'A cool channel.' }
    end

    context 'given a snippet without a description' do
      let(:attrs) { {snippet: {}} }
      it { expect(channel.description).to eq '' }
    end
  end

  describe '#made_for_kids?' do
    context 'given fetching a status returns madeForKids true' do
      let(:attrs) { {status: {"madeForKids"=>true}} }
      it { expect(channel).to be_made_for_kids }
    end

    context 'given fetching a status returns madeForKids false' do
      let(:attrs) { {status: {"madeForKids"=>false}} }
      it { expect(channel).not_to be_made_for_kids }
    end
  end

  describe '#self_declared_made_for_kids?' do
    context 'given fetching a status returns selfDeclaredMadeForKids true' do
      let(:attrs) { {status: {"selfDeclaredMadeForKids"=>true}} }
      it { expect(channel).to be_self_declared_made_for_kids }
    end

    context 'given fetching a status returns selfDeclaredMadeForKids false' do
      let(:attrs) { {status: {"selfDeclaredMadeForKids"=>false}} }
      it { expect(channel).not_to be_self_declared_made_for_kids }
    end
  end

  describe '#thumbnail_url' do
    context 'given a snippet with thumbnails' do
      let(:attrs) { {snippet: {"thumbnails"=>{
        "default"=>{"url"=> "http://example.com/88x88.jpg"},
        "medium"=>{"url"=> "http://example.com/240x240.jpg"},
      }}} }
      it { expect(channel.thumbnail_url).to eq 'http://example.com/88x88.jpg' }
      it { expect(channel.thumbnail_url 'default').to eq 'http://example.com/88x88.jpg' }
      it { expect(channel.thumbnail_url :default).to eq 'http://example.com/88x88.jpg' }
      it { expect(channel.thumbnail_url :medium).to eq 'http://example.com/240x240.jpg' }
      it { expect(channel.thumbnail_url :high).to be_nil }
    end

    context 'given a snippet without thumbnails' do
      let(:attrs) { {snippet: {}} }
      it { expect(channel.thumbnail_url).to be_nil }
    end
  end

  describe '#published_at' do
    context 'given a snippet with a timestamp' do
      let(:attrs) { {snippet: {"publishedAt"=>"2014-04-22T19:14:49.000Z"}} }
      it { expect(channel.published_at.year).to be 2014 }
    end
  end

  describe '#video_count' do
    context 'given a video with videos' do
      let(:attrs) { {statistics: {"videoCount"=>"42"}} }
      it { expect(channel.video_count).to be 42 }
    end
  end

  describe '#subscriber_count' do
    context 'given a video with subscribers' do
      let(:attrs) { {statistics: {"subscriberCount"=>"12"}} }
      it { expect(channel.subscriber_count).to be 12 }
    end
  end

  describe '#subscriber_count_visible?' do
    context 'given a video with publicly visible subscribers' do
      let(:attrs) { {statistics: {"hiddenSubscriberCount"=>false}} }
      it { expect(channel).to be_subscriber_count_visible }
    end

    context 'given a video with hidden subscribers' do
      let(:attrs) { {statistics: {"hiddenSubscriberCount"=>true}} }
      it { expect(channel).not_to be_subscriber_count_visible }
    end
  end

  describe '#content_owner' do
    context 'given a content_owner_detail with a content owner' do
      let(:attrs) { {content_owner_details: {"contentOwner"=>"FullScreen"}} }
      it { expect(channel.content_owner).to eq 'FullScreen' }
    end

    context 'given a content_owner_detail without a content owner' do
      let(:attrs) { {content_owner_details: {}} }
      it { expect(channel.content_owner).to be_nil }
    end
  end

  describe '#linked_at' do
    context 'given a content_owner_detail with a timeLinked' do
      let(:attrs) { {content_owner_details: {"timeLinked"=>"2014-04-22T19:14:49.000Z"}} }
      it { expect(channel.linked_at.year).to be 2014 }
    end

    context 'given a content_owner_detail with a timeLinked' do
      let(:attrs) { {content_owner_details: {}} }
      it { expect(channel.linked_at).to be_nil }
    end
  end

  describe '#snippet' do
    context 'given fetching a channel returns a snippet' do
      let(:attrs) { {snippet: {"title"=>"Fullscreen"}} }
      it { expect(channel.snippet).to be_a Yt::Snippet }
    end
  end

  describe '#status' do
    context 'given fetching a channel returns a status' do
      let(:attrs) { {status: {"privacyStatus"=>"public"}} }
      it { expect(channel.status).to be_a Yt::Status }
    end
  end
end
