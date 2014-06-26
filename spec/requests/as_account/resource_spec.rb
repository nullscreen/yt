require 'spec_helper'
require 'yt/models/resource'

describe Yt::Resource, :device_app do
  subject(:resource) { Yt::Resource.new url: url, auth: $account }

  describe '#id' do
    context 'given a URL containing an existing username' do
      let(:url) { 'youtube.com/fullscreen' }
      it { expect(resource.id).to eq 'UCxO1tY8h1AhOz0T4ENwmpow' }
    end

    context 'given a URL containing an unknown username' do
      let(:url) { 'youtube.com/--not--a--valid--username' }
      it { expect{resource.id}.to raise_error Yt::Errors::NoItems }
    end
  end
end