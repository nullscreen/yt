# encoding: UTF-8
require 'spec_helper'
require 'yt/collections/videos'

describe Yt::Collections::Videos, :server_app do
  subject(:videos) { Yt::Collections::Videos.new }

  specify 'without :where conditions, returns all YouTube videos', :ruby2 do
    expect(videos.size).to be > 100_000
  end

  specify 'with a query term, only returns some YouTube videos' do
    expect(videos.where(q: 'Fullscreen CreatorPlatform', video_duration: :long).size).to be < 100_000
  end

  context 'with a list of video IDs, only returns the videos matching those IDs' do
    let(:video_id) { '9bZkp7q19f0' }
    let(:videos_by_id) { videos.where id: "#{video_id},invalid" }

    it { expect(videos_by_id.size).to be 1 }
    it { expect(videos_by_id.first.id).to eq video_id }
  end

  specify 'with a chart parameter, only returns videos of that chart', :ruby2 do
    expect(videos.where(chart: 'mostPopular').size).to be 200
  end

  context 'with a list of parts' do
    let(:video_id) { '9bZkp7q19f0' }
    let(:part) { 'statistics,contentDetails' }
    let(:video) { videos.where(id: '9bZkp7q19f0', part: part).first }

    specify 'load ONLY the specified parts of the videos' do
      expect(video.instance_variable_defined? :@snippet).to be false
      expect(video.instance_variable_defined? :@status).to be false
      expect(video.instance_variable_defined? :@statistics_set).to be true
      expect(video.instance_variable_defined? :@content_detail).to be true
    end
  end
end
