require 'spec_helper'
require 'googol/youtube_resource'

describe Googol::YoutubeResource do
  context 'given the vanity URL for the R.E.M. channel' do
    before :all do
      @channel = Googol::YoutubeResource.new url: 'youtube.com/remhq'
    end

    it {expect(@channel.kind).to eq 'channel'}
    it {expect(@channel.id).to be}
    it {expect(@channel.title).to be}
    it {expect(@channel.description).to be}
    it {expect(@channel.thumbnail_url).to be}
  end

  context 'given the user URL for the R.E.M. channel' do
    before :all do
      @channel = Googol::YoutubeResource.new url: 'www.youtube.com/user/remhq'
    end

    it {expect(@channel.kind).to eq 'channel'}
    it {expect(@channel.id).to be}
  end

  context 'given the full URL for the R.E.M. channel' do
    before :all do
      url = 'https://www.youtube.com/channel/UC7eaRqtonpyiYw0Pns0Au_g'
      @channel = Googol::YoutubeResource.new url: url
    end

    it {expect(@channel.kind).to eq 'channel'}
    it {expect(@channel.id).to be}
  end

  context 'given the URL for the "Tongue" video by R.E.M.' do
    before :all do
      url = 'http://www.youtube.com/watch?v=Kd5M17e7Wek'
      @channel = Googol::YoutubeResource.new url: url
    end

    it {expect(@channel.kind).to eq 'video'}
    it {expect(@channel.id).to be}
  end

  context 'given the vanity URL for the "Tongue" video by R.E.M.' do
    before :all do
      @channel = Googol::YoutubeResource.new url: 'youtu.be/Kd5M17e7Wek'
    end

    it {expect(@channel.kind).to eq 'video'}
    it {expect(@channel.id).to be}
  end

  context 'given an invalid Youtube URL' do
    before :all do
      @channel = Googol::YoutubeResource.new url: 'youtu.be/InvalidVideoId'
    end

    it {expect{@channel.id}.to raise_error Googol::RequestError}
  end

  context 'given a non-Youtube URL' do
    before :all do
      @channel = Googol::YoutubeResource.new url: 'example.com/not-youtube'
    end

    it {expect{@channel.id}.to raise_error Googol::RequestError}
  end
end