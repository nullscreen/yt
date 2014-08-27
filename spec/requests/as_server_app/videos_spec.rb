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

  specify 'with a list of video IDs, only returns the videos matching those IDs' do
    expect(videos.where(id: 'MESycYJytkU,invalid').size).to be 1
  end

  specify 'with a chart parameter, only returns videos of that chart', :ruby2 do
    expect(videos.where(chart: 'mostPopular').size).to be 200
  end
end