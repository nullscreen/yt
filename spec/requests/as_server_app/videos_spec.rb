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
end