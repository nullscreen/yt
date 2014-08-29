require 'spec_helper'
require 'yt/models/resource'

describe Yt::Resource, :server_app do
  subject(:resource) { Yt::Resource.new url: url }

  context 'given the URL of an existing channel' do
    let(:url) { 'youtube.com/fullscreen' }

    specify 'provides access to its data' do
      expect(resource.id).to eq 'UCxO1tY8h1AhOz0T4ENwmpow'
      expect(resource.title).to eq 'Fullscreen'
      expect(resource.privacy_status).to eq 'public'
    end
  end

  context 'given the URL of an existing video' do
    let(:url) { 'https://www.youtube.com/watch?v=MESycYJytkU&list=LLxO1tY8h1AhOz0T4ENwmpow' }

    specify 'provides access to its data' do
      expect(resource.id).to eq 'MESycYJytkU'
      expect(resource.title).to eq 'Fullscreen Creator Platform'
      expect(resource.privacy_status).to eq 'public'
    end
  end

  context 'given the URL of an existing playlist' do
    let(:url) { 'https://www.youtube.com/playlist?list=LLxO1tY8h1AhOz0T4ENwmpow' }

    specify 'provides access to its data' do
      expect(resource.id).to eq 'LLxO1tY8h1AhOz0T4ENwmpow'
      expect(resource.title).to eq 'Liked videos'
      expect(resource.privacy_status).to eq 'public'
    end
  end

  context 'given an unknown URL' do
    let(:url) { 'youtube.com/--not-a-valid-url--' }

    specify 'accessing its data raises an error' do
      expect{resource.id}.to raise_error Yt::Errors::NoItems
      expect{resource.title}.to raise_error Yt::Errors::NoItems
      expect{resource.status}.to raise_error Yt::Errors::NoItems
    end
  end
end